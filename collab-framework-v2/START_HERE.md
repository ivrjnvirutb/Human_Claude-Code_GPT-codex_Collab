# Start Here: Claude-Led Collaboration Setup

Goal: Upload this folder to a target repo, then let Claude guide setup by asking project-specific questions.

---

## What to tell Claude

Use this instruction in the target repo session:

"Read `collab-framework-v2/` completely. Run collaboration setup interview mode: first auto-detect whether this repo looks fresh or migration, ask me to confirm mode choice, then ask tailoring questions needed to finalize `collaboration-profile.yaml`, run scaffold in dry-run first, show planned changes, and apply only after my approval."

---

## Expected Claude behavior

1. Read:
- `collab-framework-v2/framework-v2.md`
- `collab-framework-v2/collaboration-profile.yaml`
- `collab-framework-v2/scripts/scaffold-collab.sh`

2. Auto-detect recommended mode from project state and ask Human to confirm as one of the first questions.

3. Ask tailoring questions (scope, validation mode, branch policy, push policy, BLOCKED rules, output policy, cadence, automation mode).

4. Run dry-run first in auto-detect mode:
```bash
collab-framework-v2/scripts/scaffold-collab.sh --mode auto --profile collab-framework-v2/collaboration-profile.yaml --dry-run
```

5. Present recommendation, planned file changes, and any migration audit output.

6. Apply only after explicit approval (with explicit confirmed mode):
```bash
collab-framework-v2/scripts/scaffold-collab.sh --mode <fresh|migrate> --profile collab-framework-v2/collaboration-profile.yaml
```

7. Summarize what changed and next operational steps.

---

## Safety rules

- In existing repos, do not overwrite mature files without explicit approval.
- If migration conflict appears, resolve policy precedence before applying.
- Keep one source of truth for agent behavior (`AGENTS.md`).
