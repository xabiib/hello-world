---
name: branch-and-push
description: Create a branch, commit changes, and push to origin.
---

## Workflow
1. Create and checkout branch: `git checkout -b ${input:branchName}`
2. Stage all changes: `git add -A`
3. Read `git diff --cached` and generate a Conventional Commit message
   (e.g. `feat: ...`, `fix: ...`) from the changes.
4. Commit with that message.
5. Push: `git push -u origin ${input:branchName}`   
