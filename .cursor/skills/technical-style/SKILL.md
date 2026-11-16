---
name: technical-style
description: Style for technical writing related to code, namely best practices for links and backticks. Use for Git commit, PRs, issues, and discussions.
---

# technical-style

- Wrap technical terms in backticks.
  Examples include: class names (e.g. `SomeClass`), CLI commands (`pip install -e .`),
  variables (`MAX_RETRIES`)
- Avoid short references, such as GitHub's `#430` or `org/repo#430`
  and GitLab's `!430` or `group/project!430`,
  since beyond the host's web UI, they're plain text the reader has to look up.
  Use complete URLs: `https://github.com/sirmalloc/ccstatusline/pull/430`
  not `sirmalloc/ccstatusline#430` or `#430`.
- When linking to code, prefer using version-pinned permalinks (Git tag or Git commit SHA)
  with relevant lines, as links to branches can drift over time.
  For example with GitHub, link to `v0.160.0` for tag v0.160.0 with `#L31` to link line 31.
