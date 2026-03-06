# Collaboration Framework v2 Bundle

## Files
- `framework-v2.md`
- `collaboration-profile.yaml`
- `scripts/scaffold-collab.sh`
- `START_HERE.md`

## Quick start (Claude-led)
1. Copy this folder into the target repo root.
2. In Claude Code, ask Claude to read `collab-framework-v2/START_HERE.md` and execute that flow.

Claude will:
- auto-detect `fresh` or `migrate`
- confirm mode choice with you first
- ask setup questions
- run dry-run first
- apply after your approval

## npm usage (advanced)

If this framework is published to npm, advanced users can run:

```bash
# detect and preview
npx collab-framework-v2-skill init --mode auto --dry-run

# apply after confirmation
npx collab-framework-v2-skill init --mode <fresh|migrate>
```
