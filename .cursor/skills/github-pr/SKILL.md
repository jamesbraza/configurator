---
name: github-pr
description: Write a GitHub pull request. Use whenever drafting, making, or editing a PR body, title, or both.
---

# github-pr

## Title

- PR reviewers are often not "in the weeds," so sum up the change as a whole.
- Do not restate exact changes, unless the PR happens to be very atomic.
- When the right title is unclear, ask the user with 3-5 options.

## Body layout

If the PR layout is not dictated by a GitHub Pull Request template, use this layout.

Open the PR body with a concise (1-3 sentence) summary in the user's voice,
so reviewers can see a high-level explanation with the user's perspective.
A product manager (not necessarily a technical implementer)
should be able to understand this summary.
Feel free to include an image/screenshot/diagram here for context.

Now in the rest of the body, place the full verbosity PR description.
This description can be drafted without being concise or in a user-like phraseology.
Place this body in a default-collapsed `<details>` block,
with a `<summary>` label indicating the model provider and model that wrote the description.
This collapsed block avoids overwhelming PR reviewers with a wall of text.

```markdown
1-3 sentences: what this PR is for.

Optionally and when relevant, include an image (e.g. screenshot, diagram) epitomizing the change.

<details>
<summary>(Provider) (Model)</summary>

Agent-written description, in Markdown.

</details>
```

Where "(Provider) (Model)" can be entries like "Anthropic Claude Opus 5.5" or "OpenAI GPT-6 Sol."

## Body content

- Git commit diffs shows what changed
  and Git commit messages document details for each change.
  The PR body documents rationale that extends across all commits.
- Do not blindly restate Git commits or the diff (unless changes are trivial),
  as PR reviewers can click into individual commits or review diff separately.
  The PR body should holistically speak about all commits together. For intuition,
  think: after a squash-and-merge the PR body becomes a singular Git commit body.
- Document rationale and events that the PR is addressing.
  For example, if a code crash led to three Git commits in a bugfix PR,
  it's helpful to restate the stack trace in the PR description.
- Log future work or unimplemented nice-to-haves, for example:
  "A refactor of (insert code) to remove (insert assumption) can eliminate this bug."
- Prefer encapsulated PRs; avoid talking about downstream PRs
  unless they are actively planned and being opened imminently.
- To record an event, try to document relevant log lines, links, timestamps, versions,
  and other noteworthy details.
  - Avoid leaking secrets when recording events.
  - Avoid Git SHAs on the current Git branch, as they will change with Git rebases.
  - Avoid unnecessary setup-specifics such as machine-local paths or configurations.
    If a configuration value matters, just restate the value.
  - If we are going to a latest version, say "latest" as well as listing the version.
- Don't report verifications that Git hooks or CI checks pass,
  as these can become invalid after Git rebases, and live beyond the PR.
  For example, don't record "pre-commit passes" or "tests pass."

## Style

- Follow the `technical-style` skill: load it if it isn't loaded yet.
- Don't use semantic line feeds in PR body (e.g.paragraphs or list items),
  as GitHub renders newlines as a line break,
  leading to PR descriptions visually appearing as ragged lines.

## Process

- If we are opening the PR, assign the PR to me (e.g. `gh` CLI's `--assign @me`)
- Add a label. If the user describes the label (e.g. "label as a bug"),
  use the existing repo label matching that description.
  Otherwise pick the best fit from `gh label list`.
  - Don't create a new label without asking.
