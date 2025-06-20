module.exports = async (topicTitle, folderPath) => {
  if (!folderPath) throw new Error("Missing folder path");
  console.log(`Generating filename for topic: ${topicTitle}, in folder: ${folderPath}`);
  const pathParts = folderPath.split("/");
  const prefixParts = [];
  console.log(`Path parts: ${pathParts}`);
  for (const part of pathParts) {
    console.log(`Processing path part: ${part}`);
    const match = part.match(/^(\d+(?:\.\d+)*)/);
    console.log(`Processing part: ${part}, Match: ${match}`);
    if (match) prefixParts.push(match[1]);
  }
  const prefixBase = prefixParts.join(".");
  const matchRegex = new RegExp(`^${prefixBase}\\.(\\d{2})-`);
  console.log(`Prefix base: ${prefixBase}, Match regex: ${matchRegex}`);
  const files = app.vault.getFiles().filter(f => {
  const fileFolder = f.path.split("/").slice(0, -1).join("/");
  return fileFolder === folderPath;
});
  console.log(`Found ${files.length} files in folder: ${folderPath}`);
  const names = files.map(f => f.name);
  console.log(`Files in folder: ${names}`);
  const numbers = names
    .map(n => {
      const match = n.match(matchRegex);
      return match ? parseInt(match[1]) : null;
    })
    .filter(n => n !== null);
  console.log(`Extracted numbers: ${numbers}`);
  const next = (Math.max(...numbers, 0) + 1).toString().padStart(2, "0");
  const slug = topicTitle.trim().toLowerCase().replace(/[^a-z0-9]+/g, "-");
  console.log(`Next number: ${next}, Slug: ${slug}`);
  return `${prefixBase}.${next}-${slug}`;
};
