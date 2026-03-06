# Human <—> Claude Code <—> GPT Codex

A practical framework for reliable **Human + Claude + Codex** collaboration.

This package helps teams move from ad-hoc prompting to a structured, repeatable workflow with clear roles, scoped execution, and governance checkpoints.

---

## Advanced Install

Users who already know how to work with npm can install the packaged skill directly with:

```bash
npx @rookfolio/collab-framework-skill install --project
```

That path is intended for advanced users who want tighter skill-based integration rather than a manual folder install.

---

## Scope (Important)

This collaboration package is designed for:
- **Human**: mission owner, constraints, and final acceptance
- **Claude**: planning, orchestration, governance, and quality control
- **Codex**: scoped implementation, execution handoffs, and structured delivery artifacts

This package is **not** intended for:
- generalized subagent orchestration systems
- agent swarm frameworks

Those are separate patterns and should be documented independently.

---

## Why This Exists

Most AI-assisted projects fail for process reasons, not model quality:
- unclear handoffs
- scope drift
- conflicting instructions
- inconsistent review standards

This framework addresses those problems with a lightweight operating model that works for both:
- new projects using a `fresh` setup
- mature projects using a `migration` overlay

---

## Public GitHub Release

This public GitHub repo is intentionally minimal.

It contains:
- this `README.md`
- the `collab-framework-v2/` folder

That is the whole public release surface by design.

The goal is to let people:
- inspect the raw files directly on GitHub
- download the folder manually without extra tooling
- start a fresh Claude Code session and install step by step

---

## Recommended Install Path

This is the main path for most users.

1. Download this repo from GitHub.
2. Copy `collab-framework-v2/` into the root of the repo you want to work on.
3. Start a new Claude Code session inside that target repo.
4. Ask Claude to read `collab-framework-v2/START_HERE.md`.
5. Let Claude guide the setup flow from there.

This path is intentionally inspectable and low-friction. Users can read the raw files first, understand the framework, and then install it manually.

---

## What Claude Should Do

After reading `START_HERE.md`, Claude should:

1. read the framework files in `collab-framework-v2/`
2. inspect the target repo state
3. recommend either `fresh` or `migrate`
4. ask the user to confirm that mode
5. ask tailoring questions where needed
6. run the scaffold in dry-run mode first
7. show the planned changes
8. apply only after explicit approval

---

## What You Get

```text
collab-framework-v2/
├── framework-v2.md
├── START_HERE.md
├── collaboration-profile.yaml
├── LICENSE
├── README.md
└── scripts/
    └── scaffold-collab.sh
```

### What Each File Does

- `framework-v2.md`: the full methodology and operating model
- `START_HERE.md`: the onboarding instruction for a new Claude Code session
- `collaboration-profile.yaml`: the project-specific configuration template
- `scripts/scaffold-collab.sh`: the setup script that handles `auto`, `fresh`, and `migrate`
- `README.md` inside the folder: the quick-start for the portable bundle

---

## Core Ideas

1. **Dynamic Stage 0 (Prompt Refinement Gate)**
   Trigger when complexity or ambiguity is high to reduce avoidable rework before implementation starts.

2. **Single Source of Truth**
   Explicit instruction precedence: `AGENTS.md` > prompt > plan > supporting docs.

3. **Scoped Execution**
   Plans define `Read Scope`, `Write Scope`, and `Forbidden Scope`.

4. **Hard-Stop Escalation (`BLOCKED`)**
   Prevent unsafe assumptions when schema, scope, or safety is ambiguous.

5. **Completion Gates + Collaboration Hygiene**
   Capture implementation evidence, validation status, and handoff quality before closure.

---

## Fresh Install vs Migration Overlay

### Fresh

Use `fresh` when the repo is new or does not already have a mature collaboration structure.

### Migrate

Use `migrate` when the repo already has working docs, habits, or governance that should be preserved and upgraded carefully.

Migration is designed not to blindly overwrite mature project docs.

---

## Who This Is For

- teams working Human + Claude only
- teams working Human + Claude + Codex
- technical leads who want more reliable AI execution quality
- users who want a reusable collaboration template across multiple repos

---

## License / Reuse

MIT. See [collab-framework-v2/LICENSE](/Users/lar/librAIry/collab-framework-v2/LICENSE).
