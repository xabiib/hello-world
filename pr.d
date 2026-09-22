## 1. create-pr — create a PR with auto-generated description
# .github/skills/create-pr/SKILL.md 

  ---
name: create-pr
description: Create a GitHub pull request with an auto-generated title and description from the branch diff.
argument-hint: '<base-branch>'
---

## Workflow
1. Determine the current branch name.
2. Run `git log ${input:baseBranch}..HEAD --oneline` to list commits.
3. Run `git diff ${input:baseBranch}...HEAD --stat` for a change summary.
4. Generate a PR title (Conventional Commit style) and a description with:
   - **What changed** (bullet list from commit log)
   - **Why** (inferred from context or ask user)
   - **How to test** (if applicable)
5. Run:
   gh pr create --base ${input:baseBranch} --title "<title>" --body "<description>"  

  ## 2. review-summary — summarize Copilot review comments
  #.github/skills/review-summary/SKILL.md 

  ---
name: review-summary
description: Summarize all Copilot code review comments on a PR into a prioritized action list.
argument-hint: '<pr-number>'
---

## Workflow
1. Run `gh pr view ${input:prNumber} --json reviews,comments` to fetch review data.
2. Filter for comments authored by Copilot.
3. Categorize each finding by severity:
   - **Critical** — bugs, security issues, data loss
   - **Warning** — potential issues, missing error handling
   - **Suggestion** — style, naming, minor improvements
4. Output a markdown table:
   | # | Severity | File | Line | Finding | Suggested Fix |
5. Append a one-paragraph summary at the top.   

     ## branch-and-push  →  create-pr  →  (Copilot auto-review)  →  review-summary  →  copilot-pr-autopilot   
     # That covers: branch + commit + push → PR creation → AI review → summary → auto-fix loop.
