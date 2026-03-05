# Human <—> Claude Code <—> GPT Codex

A practical framework for reliable **Human + Claude + Codex** collaboration.

This package helps teams move from ad-hoc prompting to a structured, repeatable workflow with clear roles, scoped execution, and governance checkpoints.

---

## Scope (Important)

This package is designed for:
- **Human + Claude (planning/governance workflows) + Codex (execution handoffs and controls)**

This package is **not** intended for:
- Claude Code agentic-team deployment frameworks
- generalized subagent orchestration systems

Those are separate patterns and should be documented independently.

---

## Why This Exists

Most AI-assisted projects fail for process reasons, not model quality:
- unclear handoffs
- scope drift
- conflicting instructions
- inconsistent review standards

This framework addresses those problems with a lightweight operating model that works for both:
- new projects (`fresh` setup)
- mature projects with existing workflows (`migration` overlay)

---

## What You Get

```text
collab-framework-v2/
├── framework-v2.md                # full methodology
├── START_HERE.md                  # one-file onboarding instructions
├── collaboration-profile.yaml     # project-specific configuration
├── scripts/
│   └── scaffold-collab.sh         # executable setup (auto/fresh/migrate)
└── README.md                      # package quick start
```

---

## Core Ideas

1. **Dynamic Stage 0 (Prompt Refinement Gate)**
   - Triggered when complexity/ambiguity is high.
   - Reduces rework before implementation begins.

2. **Single Source of Truth**
   - Explicit instruction precedence (`AGENTS` > prompt > plan > supporting docs).

3. **Scoped Execution**
   - Every plan defines `Read Scope`, `Write Scope`, `Forbidden Scope`.

4. **Hard-Stop Escalation (`BLOCKED`)**
   - Prevents unsafe assumptions on schema/scope/safety ambiguities.

5. **Completion Gates + Metrics**
   - Track reliability signals (rework loops, scope drift, handoff completeness, etc.).

---

## Setup Paths

### 1) Fresh Install (new repo or Human+Claude-only project)
Generate baseline collaboration files and establish a clean Human+Claude operating contract first.  
You can add Codex delegation later without redesigning the workflow.

### 2) Migration Overlay (existing Human+Claude+Codex setup)
Detect current state, preserve mature docs, generate a migration audit, and patch governance gaps safely without wiping project history.

---

## Quick Start

1. Add the `collab-framework-v2/` folder to your target repo root.
2. In Claude Code, run the onboarding instruction from `START_HERE.md`.
3. Let Claude:
   - auto-detect recommended mode (`fresh` or `migrate`)
   - confirm mode with you first
   - ask tailoring questions
   - run dry-run first
   - apply only after your approval

Direct commands:

```bash
# Step 1: detect mode and preview changes
collab-framework-v2/scripts/scaffold-collab.sh \
  --mode auto \
  --profile collab-framework-v2/collaboration-profile.yaml \
  --dry-run

# Step 2: after confirmation, apply explicit mode
collab-framework-v2/scripts/scaffold-collab.sh \
  --mode <fresh|migrate> \
  --profile collab-framework-v2/collaboration-profile.yaml
```

---

## Who This Is For

- teams working Human+Claude only
- teams working Human+Claude+Codex
- technical leads who want reliable AI execution quality
- projects where handoffs and governance matter

---

## Practical Benefits

- less ambiguity before coding starts
- fewer iteration loops caused by missing constraints
- safer execution boundaries
- clearer accountability between human and agents
- easier reuse across different project types

---

## Notes

- This framework is designed to be **adaptable**, not rigid.
- It is not a substitute for human judgment.
- Success depends on good project-specific profile configuration.
- It focuses on collaboration governance and handoff quality, not agentic team deployment.

---

## License / Reuse

Use, adapt, and extend for your team workflows.
If you publish improvements, share back lessons learned.

