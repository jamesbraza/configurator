---
name: commit-pr
description: Stage, commit, push, and open a GitHub pull request for the current work. Use when asked to commit and open a PR.
---

# commit-pr

1. Never commit directly to the repo's default branch (e.g. `main`, `dev`).
   If one of those branches is checked out, create a new branch.
2. When creating a new branch, if the name is obvious and available go ahead.
   Otherwise, propose 3-5 possible branch names to the user.
3. Stage all changes that belong to the work: tracked modifications
   plus untracked files that are part of it.
   - If any untracked files look unrelated, list them and ask before staging them.
4. Commit the changes across 1+ Git commits, splitting them into logical units.
   Follow the `git-commit` skill, loading it if it isn't loaded yet.
5. Open the pull request following the `github-pr` skill.
   Load it if it isn't loaded yet.
   Target the default branch unless the user specifies a different base branch.
