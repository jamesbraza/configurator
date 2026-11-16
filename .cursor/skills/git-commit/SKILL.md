---
name: git-commit
description: Write Git commit message(s). Use whenever drafting, making, or amending a Git commit.
---

# git-commit

## Subject

- Give a subject line that sums up this particular change, in isolation.
- The diff shows what is changed, so don't list every edit.
  Though don't be afraid to use specifics.

## Body

- The diff shows what is changed; the body is the place to record rationale
  and events not otherwise reflected in the diff.
  Examples of rationale include motivation, trade-offs, and user feedback.
- Don't reiterate the diff, the commit body complements the diff.
- The body should facilitate software archaeology long after the change.
- To record an event, try to document relevant log lines, links, timestamps, versions,
  and other noteworthy details.
  - Avoid leaking secrets when recording events.
  - Avoid Git SHAs on the current Git branch, as they will change with Git rebases.
  - Avoid unnecessary setup-specifics such as machine-local paths or configurations.
    If a configuration value matters, just restate the value.
  - If we are going to a latest version, say "latest" as well as listing the version.
- Don't report verifications that Git hooks beyond the commit pass,
  as these can become invalid after Git rebases, and live beyond the commit.
  For example, don't record "pre-commit passes."

## Style

Follow the `technical-style` skill: load it if it isn't loaded yet.
