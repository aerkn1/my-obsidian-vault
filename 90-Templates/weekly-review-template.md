<%*
const topic = await tp.system.prompt("Topic?");

const folder = tp.file.folder();

const newName = await tp.user.generate_prefix_filename(topic, folder);

await tp.file.rename(newName);
%>

# <% topic %>

## Problem Statement
...

## Solution
...

## Complexity
- Time: 
- Space: 





