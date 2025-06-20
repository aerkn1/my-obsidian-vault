# FastAPI Topic: {{topic}}

## Overview
...

## Example
\`\`\`python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}
\`\`\`

## Related
[[Pydantic]], [[APIRouter]]
