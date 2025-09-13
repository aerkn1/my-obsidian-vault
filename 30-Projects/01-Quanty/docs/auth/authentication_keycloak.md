
# Authentication & Authorization (Keycloak Edition) — Authoritative Guide

**Project:** Trade‑Analytics Platform  
**Audience:** Backend, frontend, DevOps engineers integrating Identity & Access Management (IAM).  
**Scope:** Full Keycloak design tailored to our microservices (GraphQL Gateway, Inference, Confirm, Reco, Notification, etc.), RabbitMQ bus headers, mobile/web clients, and service‑to‑service (S2S) calls. Includes realm configuration, clients, roles/scopes, token contents, mappers, lifetimes, flows, integration code, auditing, and operational SOPs.

> Analogy: Keycloak is our **security switchboard**. It speaks OAuth2/OIDC/SAML to users and hands services **stamped tickets** (JWTs) that encode *who*, *which tenant*, and *what they’re allowed to do*.

---

## 0) Design Principles (specific to this app)

1. **Single realm** (`trading`): reduces admin overhead; tenants are **claims**, not realms.  
2. **Clients = entry points**: SPA/mobile (`gateway-web`), server (`gateway-server`), and each microservice (`svc-*`) are Keycloak clients.  
3. **RBAC via roles + scopes**: coarse roles (`admin`, `analyst`, `viewer`) + granular **scopes** (`gql.read`, `trade.read`, `trade.create`, `model.read`).  
4. **Tenant in every token**: `tenant_id` and optional `tenant_roles` emitted via **protocol mappers**.  
5. **Short‑lived access tokens** (15–30 min) + **rotating refresh tokens**. No opaque sessions on services; JWT everywhere.  
6. **Service‑to‑service**: OAuth2 **client‑credentials** (short‑lived JWT) or **mTLS**.  
7. **API keys**: continue using our **per‑user API key service** (Keycloak does not natively manage per‑user API keys elegantly). Gateway exchanges API keys for short‑lived internal JWTs.  
8. **Zero trust on the bus**: RabbitMQ messages carry **tenant_id**, **user_id** (if end‑user initiated), **svc** headers signed implicitly by JWT on the producing side; consumers still validate authorization at their boundary.  
9. **Auditable**: enable Keycloak **Event** and **Admin** logs; pipe to central logging.

---

## 1) Realm Topology

- **Realm:** `trading`
- **Clients:**
  - `gateway-web` — **public** client (PKCE). SPA (React/Vue) & mobile (Flutter/RN).  
  - `gateway-server` — **confidential** client for GraphQL Gateway (Go).  
  - `svc-inference`, `svc-confirm`, `svc-reco`, `svc-notify`, `svc-gql`, `svc-mlops` — **confidential** clients for machine tokens.  
- **Client Scopes (default scopes attached to tokens):**
  - `roles` (built-in)
  - `profile` (name/email if needed)
  - `tenant` (**custom**) – adds `tenant_id` and `tenant_roles` claims
  - `scopes` (**custom**) – adds fine-grained **scopes** claim
- **Groups (optional):** `tenant:<TENANT_NAME>` – if you prefer group-based tenancy management in UI.
- **Roles (realm-level):** `admin`, `analyst`, `viewer`, plus service roles: `svc_inference`, `svc_confirm`, `svc_reco`, etc.

### 1.1 Tenancy model
- Users can belong to **multiple tenants**. Keep tenant membership in app DB (`ops.user_tenants`) **and** mirror a *primary* `tenant_id` in Keycloak as a **user attribute** for token emission.  
- For multi‑tenant switching in UI: the SPA requests a new token with `tenant_id` in `authorization_details` or via an **Account Console** custom page (simpler: call `/auth/token?requested_tenant=<id>` endpoint in Gateway that triggers Keycloak `token-exchange` with a mapper override).  
- **Protocol mapper** (see below) ensures `tenant_id` claim is always present; UI sets/changes it via a simple gateway endpoint which stores preferred tenant in Keycloak user attributes.

---

## 2) Roles & Scopes

### 2.1 Realm roles
- `admin` — full access to tenant data + admin endpoints.
- `analyst` — read everything, create paper trades, read models.
- `viewer` — read-only charts, alerts, positions.

### 2.2 Fine‑grained scopes (as a custom claim `scopes`)
- `gql.read`, `gql.write`
- `trade.read`, `trade.create`, `trade.manage`
- `model.read`
- `admin.*`

> In Keycloak, scopes can be modeled as **client roles** on `gateway-server` mapped to a `scopes` custom claim. This lets the Gateway enforce per-resolver rules.

### 2.3 Service roles
Attach to service clients (`svc-*`) for S2S allow‑listing:
- `svc_inference`
- `svc_confirm`
- `svc_reco`
- `svc_notify`
- `svc_gql`
- `svc_mlops`

These get emitted as `roles` in machine tokens and are checked by receiving services.

---

## 3) Token Content & Lifetimes

### 3.1 Access token (JWT)
- **alg:** RS256 (default) or ES256 (optional)  
- **Lifetime:** 15–30 min (prod), 60 min (staging/dev)  
- **Claims (sample):**
```json
{
  "iss": "https://keycloak.local/realms/trading",
  "aud": ["gateway-server"],
  "sub": "0b6a...",
  "preferred_username": "alice",
  "tenant_id": "a3b1e2c4-...",
  "roles": ["analyst"],
  "scopes": ["gql.read","trade.read","model.read"],
  "tenant_roles": {"a3b1e2c4-...":["analyst"]},
  "exp": 1736298000,
  "iat": 1736296200,
  "jti": "b1f8...",
  "typ": "Bearer"
}
```

### 3.2 Refresh token
- **Rotation:** **on every refresh** (rotate‑on‑use)  
- **Lifetime:** 30–90 days (mobile), 7–30 days (web)  
- **Reuse detection:** If an old refresh is used after rotation, revoke **all** sessions for that user.

### 3.3 Offline tokens (optional)
For long‑running CLI tools. Keep off by default; if enabled, require TOTP/MFA and shorter lifetimes.

### 3.4 JWKS & Key rotation
- JWKS endpoint: `https://keycloak.local/realms/trading/protocol/openid-connect/certs`  
- Rotate signing keys **quarterly**. Keep old `kid` active for verification until all tokens issued with it expire.

---

## 4) Protocol Mappers (Critical)

### 4.1 `tenant_id` mapper
- **Type:** User Attribute  
- **User Attribute:** `tenant_id`  
- **Token Claim Name:** `tenant_id`  
- **Claim JSON Type:** `String`  
- **Add to ID & Access tokens:** Yes

### 4.2 `tenant_roles` mapper (optional but useful)
- **Type:** Script or User Realm Role mapper  
- **Logic:** Build a JSON map `{ tenant_id: [roles...] }` for multi-tenant users (if you store per‑tenant role bindings in Keycloak groups or attributes).  
- **Token Claim Name:** `tenant_roles`  
- **JSON Type:** JSON

### 4.3 `scopes` mapper (client roles on `gateway-server` → string array)
- **Type:** Client Role Mapper  
- **Client:** `gateway-server`  
- **Token Claim Name:** `scopes`  
- **Multivalued:** true

---

## 5) Flows (step‑by‑step)

### 5.1 Web/Mobile login (Authorization Code + PKCE)
1. SPA redirects to Keycloak `/auth` with `client_id=gateway-web`, `redirect_uri`, `scope=openid profile`, and **PKCE** `code_challenge`.  
2. User logs in (email/password, optional MFA).  
3. Keycloak redirects back with `code`; SPA posts `code` + `code_verifier` to Gateway (or directly to Keycloak if no backend).  
4. Token endpoint returns `access_token` + `refresh_token`.  
5. SPA stores tokens securely (mobile secure storage / web memory + silent refresh).  
6. Every API call → `Authorization: Bearer <access_token>`.

### 5.2 Tenant switching
- SPA calls `POST /auth/set-tenant { tenant_id }` on Gateway.  
- Gateway sets Keycloak user attribute `tenant_id` via Admin API, then requests **token exchange** to get a fresh access token with new `tenant_id`.  
- SPA replaces its token.

### 5.3 Service‑to‑Service (Client Credentials)
- Service uses its `client_id=svc-inference` + client secret to call token endpoint with `grant_type=client_credentials`.  
- Receives a **machine token** (JWT with `roles: ["svc_inference"]`, and optional `scopes`), TTL 5–10 minutes.  
- Use it to call other internal services. No refresh; just request a new token when needed.

### 5.4 API key → internal token (Gateway)
- Client sends `X-API-Key: <prefix.secret>` to Gateway.  
- Gateway validates against our API key DB (hash compare).  
- Gateway mints an **internal JWT** with `tenant_id`, `scopes` matching API key grants, short TTL (5–10 min), and uses it downstream.  
- Downstream services only ever see JWTs (uniform enforcement).

### 5.5 Refresh
- SPA/mobile calls `POST /auth/refresh` with `refresh_token`.  
- Keycloak rotates and returns new pair; Gateway updates cookies (if using httpOnly cookies).  
- On reuse detection → revoke all sessions for that user + alert.

### 5.6 Logout
- `POST /auth/logout` → Gateway calls Keycloak **logout** endpoint to end session; deletes refresh cookies; publishes `auth.logout` event if needed.

---

## 6) Client Configuration (Keycloak console)

### 6.1 `gateway-web` (public)
- **Access Type:** Public  
- **Flow:** Standard (Authorization Code)  
- **PKCE:** Required  
- **Valid Redirect URIs:** `https://app.example.com/*`  
- **Web Origins:** `https://app.example.com`  
- **Default Client Scopes:** `roles`, `profile`, `tenant`, `scopes`  
- **Login Settings:** Remember Me (optional), SSOs as needed

### 6.2 `gateway-server` (confidential)
- **Access Type:** Confidential  
- **Service Accounts:** Off (not needed)  
- **Credentials:** Client Secret (store in Vault/KMS)  
- **Default Scopes:** `roles`, `tenant`, `scopes`  
- **Direct Access Grants:** Off  
- **Permitted Scopes/Client Roles:** create `client roles` for fine‑grained `scopes`, map via mapper.

### 6.3 `svc-*` (confidential, machine)
- **Access Type:** Confidential  
- **Service Accounts Enabled:** **On** (if using Keycloak Authorization Services; otherwise optional)  
- **Credentials:** Client Secret or mTLS  
- **Token Settings:** Access Token 5–10 min; no refresh

---

## 7) Token Lifetimes & Security Settings

- **Access Token:** 15–30 min  
- **SSO Session Idle:** 30–60 min (web), 8–12 h (internal admin console)  
- **SSO Session Max:** 12–24 h  
- **Refresh Token Max Reuse:** 0 (rotate on each use)  
- **Brute Force Detection:** On (5 attempts → 15 min lockout)  
- **MFA:** Optional TOTP for admins and high‑risk tenants  
- **CORS:** Configure per client (origins, allowed headers)

---

## 8) Integrations (code)

### 8.1 GraphQL Gateway (Go, `gqlgen` + fiber/gin)
```go
import (
  "github.com/MicahParks/keyfunc"
  "github.com/golang-jwt/jwt/v5"
)

var jwks *keyfunc.JWKS
func init() {
  url := "https://keycloak.local/realms/trading/protocol/openid-connect/certs"
  jwks, _ = keyfunc.Get(url, keyfunc.Options{RefreshInterval: time.Hour})
}

func VerifyJWT(token string, aud string) (map[string]any, error) {
  t, err := jwt.Parse(token, jwks.Keyfunc,
    jwt.WithIssuer("https://keycloak.local/realms/trading"),
    jwt.WithAudience(aud),
  )
  if err != nil || !t.Valid { return nil, err }
  claims := t.Claims.(jwt.MapClaims)
  return claims, nil
}

// example middleware extracts tenant & scopes into context
```

**Resolver guards (example):**
```go
func require(scope string, next graphql.FieldResolver) graphql.FieldResolver {
  return func(ctx context.Context, obj interface{}, args interface{}) (res interface{}, err error) {
    scopes := ctx.Value("scopes").([]string)
    if !has(scopes, scope) { return nil, ErrForbidden }
    return next(ctx, obj, args)
  }
}
```

### 8.2 Java (Spring Boot) — Resource Server
```properties
spring.security.oauth2.resourceserver.jwt.issuer-uri=https://keycloak.local/realms/trading
spring.security.oauth2.resourceserver.jwt.jwk-set-uri=https://keycloak.local/realms/trading/protocol/openid-connect/certs
```
```java
@Bean SecurityFilterChain security(HttpSecurity http) throws Exception {
  http.authorizeHttpRequests(auth -> auth
     .requestMatchers("/reco/**").hasAuthority("SCOPE_trade.create")
     .anyRequest().authenticated())
     .oauth2ResourceServer().jwt();
  return http.build();
}
```

### 8.3 Python (FastAPI) — Service
```python
from jose import jwt
import httpx

JWKS_URL = "https://keycloak.local/realms/trading/protocol/openid-connect/certs"
jwks = httpx.get(JWKS_URL).json()

def decode(token:str):
    return jwt.decode(token, jwks, audience="svc-reco", issuer="https://keycloak.local/realms/trading")

@app.middleware("http")
async def auth_mw(request, call_next):
    bearer = request.headers.get("authorization","")[7:]
    claims = decode(bearer)
    request.state.tenant_id = claims["tenant_id"]
    request.state.scopes = claims.get("scopes", [])
    return await call_next(request)
```

### 8.4 RabbitMQ integration
- Producers forward request context into headers:  
  `x-tenant-id` = `tenant_id`, `x-user-id` (if end‑user), `x-svc` (service name), `x-jti` (request id).  
- Consumers validate **locally** (if HTTP ingress uses JWT); for bus, verify **once** at Gateway and enforce **per-service** RBAC at the consumer.

---

## 9) Admin & Operations

### 9.1 Deploy Keycloak
- **Docker Compose (prod‑ish single node):**
```yaml
services:
  keycloak:
    image: quay.io/keycloak/keycloak:24.0
    command: ["start"]
    environment:
      KC_DB: postgres
      KC_DB_URL: jdbc:postgresql://db:5432/keycloak
      KC_DB_USERNAME: keycloak
      KC_DB_PASSWORD: <secret>
      KC_HOSTNAME: keycloak.local
      KC_PROXY: edge
    ports: ["8080:8080"]
    depends_on: [db]
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: keycloak
      POSTGRES_USER: keycloak
      POSTGRES_PASSWORD: <secret>
    volumes: ["kcdata:/var/lib/postgresql/data"]
volumes: { kcdata: {} }
```

- For HA: run on Kubernetes, external Postgres, persistent volumes, Ingress TLS.

### 9.2 Realm bootstrap (automation)
- Keep a **realm export JSON** in git (sanitized).  
- Use `kcadm.sh` to script: create realm, clients, roles, client scopes, mappers.  
- Rotate client secrets via Vault; reference via env.

### 9.3 Events & Audit
- Enable **Login events**, **Admin events** (details on).  
- Configure Event Listener SPI (e.g., to send to Kafka/HTTP) if needed.  
- Forward Keycloak logs to central logging (Loki/Elastic).

### 9.4 Key rotation
- Create new key in `Realm Settings → Keys`; set as **active**.  
- Services fetch updated JWKS automatically (cache refresh hourly).  
- Keep old key until tokens with old `kid` expire (longest access token TTL).

### 9.5 Backups & DR
- Backup Keycloak DB + realm export nightly.  
- Document **break‑glass** admin account stored in secure vault.

---

## 10) Security Hardening

- Enforce **PKCE** for `gateway-web`.  
- Set **Content Security Policy** on app; restrict redirect URIs.  
- **MFA** required for `admin` role.  
- Short machine token TTL (≤10min).  
- Rate-limit login and token endpoints at the edge.  
- Disable user registration in prod (invite/console only).  
- Disable direct grants where not required.  
- Use **SameSite=strict** cookies if you go cookie‑based in web.

---

## 11) Authorization Strategies

### 11.1 Gateway‑enforced (recommended)
- Gateway checks `roles`, `scopes`, `tenant_id` and applies **business‑level** authorization (e.g., a user may read trades only for `tenant_id`).  
- Advantage: central policy, simpler services.

### 11.2 Keycloak Authorization Services (optional)
- If you need policy‑driven resource access (ABAC, UMA), enable Authorization on `gateway-server` and define **Policies** and **Permissions** inside Keycloak.  
- Services then call **Token Introspection** or request **RPT** tokens.  
- Note: adds complexity; not necessary for our initial rollout.

---

## 12) API Keys Strategy (with Keycloak)

Keycloak doesn’t natively issue per‑user API keys. We keep our **API Key Service**:
- API keys stored hashed in `ops.api_keys` (Postgres).  
- Gateway authenticates API keys and **mints short‑lived internal JWT** with `tenant_id`, `scopes` from the key, audience=`gateway-server`.  
- Downstream services see **only JWTs** (uniform).  
- Optionally store key metadata in Keycloak user attributes for admin visibility.

---

## 13) End‑to‑End Examples

### 13.1 SPA charts page (read)
1. SPA obtains access token from `gateway-web` flow.  
2. Calls `GET /graphql` with `Authorization: Bearer ...`.  
3. Gateway validates JWT (issuer, audience `gateway-server`), checks `scopes` has `gql.read`.  
4. Gateway queries Timescale; returns results.

### 13.2 Place trade (write)
1. SPA calls `mutation placeTrade(...)` with token.  
2. Gateway checks `trade.create` scope.  
3. Gateway publishes `ml.confirmed` → `reco` path; includes headers `x-tenant-id`, `x-user-id`.  
4. Reco validates inputs; writes `core.trades`; Notification Worker emits alert.

### 13.3 Inference calls Confirm (S2S)
1. `svc-inference` requests client‑credentials token from Keycloak.  
2. Calls Confirm API with `Authorization: Bearer <machine token>`.  
3. Confirm verifies `roles` include `svc_inference`.  
4. Responds or rejects (403).

---

## 14) Failure Modes & Mitigations

- **Clock skew** → allow ±120s leeway; NTP everywhere.  
- **JWKS stale** → library auto‑refresh; on verification failures, retry fetch JWKS immediately.  
- **Token bloat** (too many claims) → keep claims minimal (`tenant_id`, `roles`, `scopes`).  
- **Tenant mix‑ups** → require explicit tenant switch endpoint; log every change; include `tenant_id` in every DB write and MQ publish.  
- **Compromised refresh** → rotate‑on‑use + reuse detection + global session revocation.  
- **Service secret leaked** → rotate client secret; revoke; audit access; consider mTLS.

---

## 15) Checklist (DoD)

- [ ] Realm `trading` created, realm export committed.  
- [ ] Clients created: `gateway-web` (public), `gateway-server` (confidential), `svc-*` (confidential).  
- [ ] Client scopes `tenant`, `scopes` configured; **protocol mappers** tested.  
- [ ] Roles/scopes defined; admin accounts created with MFA.  
- [ ] Gateway verifies JWT via JWKS; resolvers enforce scopes.  
- [ ] Services verify machine tokens and enforce service roles.  
- [ ] API key exchange to JWT implemented in Gateway.  
- [ ] Events/Audit enabled; logs flowing to observability stack.  
- [ ] Key rotation procedure documented and tested.  
- [ ] Rate limits, brute force, and CORS set.

---

## 16) Appendix: kcadm snippets

```bash
# login admin
kcadm.sh config credentials --server https://keycloak.local --realm master --user admin --password '...'

# create realm
kcadm.sh create realms -s realm=trading -s enabled=true

# create clients
kcadm.sh create clients -r trading -f - <<EOF
{"clientId":"gateway-server","publicClient":false,"serviceAccountsEnabled":false,"standardFlowEnabled":true,"redirectUris":["https://api.example.com/*"]}
EOF

kcadm.sh create clients -r trading -f - <<EOF
{"clientId":"gateway-web","publicClient":true,"standardFlowEnabled":true,"redirectUris":["https://app.example.com/*"],"attributes":{"pkce.code.challenge.method":"S256"}}
EOF

# create realm roles
kcadm.sh create roles -r trading -s name=admin
kcadm.sh create roles -r trading -s name=analyst
kcadm.sh create roles -r trading -s name=viewer

# add protocol mapper for tenant_id on gateway-server
CID=$(kcadm.sh get clients -r trading -q clientId=gateway-server --fields id --format csv | tail -n1)
kcadm.sh create clients/$CID/protocol-mappers/models -r trading -s 'name=tenant_id' -s 'protocol=openid-connect' -s 'protocolMapper=oidc-usermodel-attribute-mapper' -s 'config."claim.name"=tenant_id' -s 'config."user.attribute"=tenant_id' -s 'config."id.token.claim"=true' -s 'config."access.token.claim"=true' -s 'config."jsonType.label"=String'
```
