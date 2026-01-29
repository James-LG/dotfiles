<%*
  // 1. Get the random name
  const randomName = await tp.user.random_name();

  // 2. Rename the file. If the file is untitled, this happens automatically.
  //    No need to wrap in an `if` block for the rename if you just want it to happen.
  await tp.file.rename(randomName);

  // 3. Use 'tR += `...`' to build and output the frontmatter and content.
  tR += `---
date: ${tp.date.now("YYYY-MM-DD")}
---
`;
_%>
