<%*
const topic = await tp.system.prompt("Topic?");

const fullPath = String(tp.file.path).split("/").slice(0, -1).join("/");

const filename = await tp.user.generate_prefix_filename(topic, fullPath);

await tp.file.rename(filename);
%>

# <% topic %>

## Problem Statement
...

## Solution
...

## Complexity
- Time: 
- Space: 

## Related