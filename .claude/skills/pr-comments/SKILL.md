---
name: pr-comments
description: Resolve outstanding PR comments on a pull request by planning changes/replies with user approvals. Use when asked to address PR comments or review feedback.
---

# pr-comments

Make sure we are in plan mode before proceeding.
If there is no plan mode, just present the plan and wait for approval before the final step.

## Steps

1. View all unresolved PR comments (e.g. for GitHub use the `gh` CLI).
2. Analyze each comment and determine if changes should be made.
   Even if you don't want to make a change,
   consider if the rationale should be documented in-source.
3. For each change, determine if a new Git commit should be made
   or if the change should be amended into Git history.
   Also determine if the PR description should be updated.
   - Follow the `git-commit` and `pull-request` skills. Load them if they aren't loaded yet.
4. Plan a reply to each comment.
   - Don't include a Git commit SHA, just state rationale,
     as the SHA will change across Git rebases.
   - Reply in-thread when a thread is present, don't reply at the PR level.
5. Ask the user to review the planned changes and replies, and wait for their approval.
6. Make the Git commits or amends, update the PR description,
   Git push (`git push --force-with-lease` if history was rewritten),
   and post the replies. If a comment has been resolved, also mark its thread as resolved.

## Style

Follow the `technical-style` skill for both subject and body.
Load it if it isn't loaded yet.
