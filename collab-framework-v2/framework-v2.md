# Claude + Codex Collaboration Framework v2

Portable framework for adapting Human/Claude/Codex workflows across project types.

---

## 1) Design Goals

- Keep Human intent central
- Reduce ambiguity before execution
- Preserve traceability and governance
- Adapt to project complexity without rigid overhead

---

## 2) Core Model (Project-Agnostic)

1. Human intent intake
2. Claude triage and complexity scoring
3. Dynamic Stage 0 when needed
4. Planning and scoped delegation
5. Execution and evidence collection
6. Human verification and closure

---

## 3) Dynamic Stage 0 (Prompt Refinement)

### Stage 0 modes

- `dynamic` (recommended default): trigger based on complexity score
- `required`: always run before planning
- `disabled`: skip (only for low-risk routine workflows)

### Complexity scoring categories (0-2 each)

- Scope breadth
- Ambiguity
- Sequencing/dependencies
- Iteration cost
- Scope-drift risk

Dynamic trigger recommendation:
- Run Stage 0 when score >= 6, or
- Any category = 2 with ambiguity >= 1, or
- Conflicting instructions/docs are detected

---

## 4) Contract Hierarchy

Define and enforce precedence in every project:

1. `AGENTS.md` (source of truth)
2. Active prompt
3. Active plan
4. Supporting docs

Any override requires explicit Human confirmation.

---

## 5) Required Artifacts

- `AGENTS.md` (authoritative contract)
- `COLLABORATION.md` (human/agent collaboration nuances)
- `MEMORY.md` (concise persistent memory)
- `plans/active/` + `plans/completed/`
- `plans/KICKOFF_TEMPLATE.md`
- `plans/automation-flags.md` (optional triage)

---

## 6) Plan Spec (Minimum)

- Goal
- Context
- Read Scope
- Write Scope
- Forbidden Scope
- Implementation Guide
- Success Criteria
- Validation Method
- Risks/Ambiguities
- Handoff Notes

---

## 7) Prompt Spec (Minimum)

- Sync step
- Read plan/context step
- Implementation step with strict write boundaries
- Commit step with naming standard
- Handoff artifact requirement
- BLOCKED escalation protocol

---

## 8) Completion Gate

A task moves from active to completed only after:

- Implementation evidence exists
- Validation status is captured
- Review notes are triaged
- Known blockers are resolved or logged
- Human confirms close/archive decision

---

## 9) Project Profile Inputs (Tailoring Questions)

Use these to adapt framework v2 per project:

1. Same-directory or isolated worktree?
2. Manual validation, CI, or both?
3. Branch naming standard?
4. Push policy for Codex and Claude?
5. File scope model (read/write/forbidden)?
6. What triggers hard BLOCKED?
7. Notebook/output policy?
8. README cadence?
9. Automation level and SLA?
10. Memory governance and audit cadence?
11. Required handoff artifact fields?
12. Parallelism boundaries?

---

## 10) Example Profiles

### A) Research/Notebook Project 

- Directory model: same-directory
- Validation: manual notebook runs
- Outputs: preserved
- Automations: minimal/disabled
- README: concise milestone updates

### B) Product/Service Project

- Directory model: optional worktree isolation
- Validation: CI + tests mandatory
- Outputs: clean diffs preferred
- Automations: bug scan, coverage, security, drift checks
- README: technical + operational runbook detail

---

## 11) Governance Anti-Drift Controls

- Single source of truth in `AGENTS.md`
- Weekly doc consistency check (`AGENTS` vs prompts vs supporting docs)
- Memory hygiene audit per milestone
- Plan lifecycle audit (`active` vs `completed`)

---

## 12) Adoption Sequence and Timing

### Two-phase onboarding for a new project

Phase 1: Discovery-first (Human + Claude)
- Run 1-3 real tasks with lightweight process
- Clarify mission, milestones, constraints, acceptance criteria
- Observe ambiguity patterns and validation style

Phase 2: Framework install (before heavy Codex delegation)
- Scaffold collaboration files
- Customize project profile and governance rules
- Begin Codex delegation using scoped plans/prompts

### Install trigger (do not delay past this point)

Install framework when any condition is true:
1. First multi-file or multi-phase Codex handoff is about to start
2. Scope ambiguity/rework has already appeared in discovery tasks
3. More than one contributor/agent needs consistent handoff rules

### Sequence after trigger

1. Establish core contract (`AGENTS.md`)
2. Configure project profile decisions
3. Add dynamic Stage 0 scoring logic
4. Run 1-2 pilot tasks under the new contract
5. Audit drift and refine
6. Publish project-specific profile snapshot

---

## 13) Scaffold Strategy (Recommended)

Use a hybrid setup approach:

1. Run a scaffold script to generate baseline collaboration files
2. Run guided customization before first real task
3. Lock setup with a one-time readiness checklist

### Support both setup paths

1. Fresh install (new repo): create full baseline package
2. Migration overlay (existing repo): preserve current files, back up existing collaboration docs, then patch gaps

Migration overlay should never blindly overwrite mature project docs.

### One template vs two templates

Default recommendation: keep one framework with two explicit flows (`fresh`, `migrate`).

Create separate templates only when both conditions are true:
1. Process divergence is substantial (for example, governance sections differ materially)
2. Teams repeatedly misapply the wrong flow despite clear mode documentation

### Scaffold script should generate

- `AGENTS.md` (template + profile placeholders)
- `COLLABORATION.md`
- `MEMORY.md`
- `plans/KICKOFF_TEMPLATE.md`
- `plans/PLAN_TEMPLATE.md`
- `plans/PROMPT_TEMPLATE.txt`
- `plans/COMPLETION_GATE.md`
- `plans/automation-flags.md`
- `plans/collaboration-metrics.md`
- `.codex/rules/<project>.rules`
- `collaboration-profile.yaml`

### Scaffold script operating modes

- `auto`: detect and recommend mode based on project state (requires explicit confirmation before apply)
- `fresh`: initialize missing files for a new project
- `migrate`: run history-aware audit, back up existing collaboration files, and generate patch recommendations

### Why hybrid instead of fully manual

- Prevents missing critical files
- Enforces consistent baseline governance
- Still allows project-specific tailoring (validation model, output policy, automation level)

---

## 14) Setup Readiness Checklist (One-Time Gate)

Before first production task:

1. Contract precedence confirmed (`AGENTS > prompt > plan > supporting docs`)
2. Branch and push policies confirmed
3. Scope model confirmed (`Read Scope`, `Write Scope`, `Forbidden Scope`)
4. BLOCKED escalation policy confirmed
5. Validation model confirmed (manual, CI, or mixed)
6. Completion gate confirmed
7. Memory audit cadence confirmed
8. Automation mode confirmed (enabled/disabled + ownership)
9. Human acceptance flow confirmed

---

## 15) collaboration-profile.yaml (Suggested Schema)

Use a machine-readable profile so setup is reproducible:

```yaml
project_name: ""
directory_model: "same-directory" # or "worktree"
stage0_mode: "dynamic" # dynamic|required|disabled
validation_mode: "manual" # manual|ci|mixed
notebook_output_policy: "preserve" # preserve|clear
branch_naming:
  codex: "codex/batchNN-short-name"
  claude: "claude/workflow-short-name"
push_policy:
  codex_push: false
  claude_push_requires_human_approval: true
readme_update_cadence: "milestone"
automation_mode: "disabled"
memory_required: true
completion_gate_required: true
```

---

## 16) Operational Metrics (Lightweight)

Track a few signals to improve workflow quality:

1. BLOCKED rate per batch
2. Rework loops to acceptance
3. Scope drift incidents
4. Time from plan-ready to completion
5. Doc drift incidents (`AGENTS` conflict count)
6. Handoff artifact completeness rate
7. Completion-gate pass rate

Use trends, not single points, to refine collaboration rules.

### Starter benchmarks (adjust per project maturity)

1. Handoff artifact completeness >= 95%
2. Completion-gate pass on first review >= 85%
3. Scope drift incidents <= 1 per 10 tasks
4. BLOCKED due to avoidable ambiguity <= 15% (rolling 10 tasks)

### Escalation triggers for workflow tuning

Run a workflow update review when any occurs:
1. Two consecutive tasks fail completion gate first pass
2. Three or more BLOCKED events in one week from missing scope clarity
3. Any severe scope violation (`Write Scope` or `Forbidden Scope` breach)
4. Rework loops trend upward for two consecutive review windows

---

## 17) Change Management for Workflow Rules

When changing collaboration rules:

1. Propose change in a short workflow note
2. Get Human approval
3. Update `AGENTS.md` first
4. Sync templates/supporting docs
5. Record rationale in `MEMORY.md`

Avoid silent policy drift.

---

## 18) Failure Modes to Guard Against

Common anti-patterns:

1. Multiple sources of truth for agent behavior
2. Vague scope boundaries in plans
3. Missing completion gates
4. Stale active plans and triage logs
5. Over-automation for low-complexity projects
6. No memory hygiene (stale/conflicting memory)

Treat these as audit checkpoints in periodic reviews.

---

## 19) Review Cadence and Benchmarks Governance

Use two review loops:

1. Weekly quick review (15-20 min)
- Check metric deltas
- Triage drift/ambiguity sources
- Apply minor rule wording updates if needed

2. Milestone retrospective (deep review)
- Re-baseline benchmark targets
- Decide whether collaboration settings should change
- Publish decisions to `AGENTS.md` and `MEMORY.md`

Keep a simple log in `plans/collaboration-metrics.md` for traceable decisions.

---

## 20) Execution Assets: Manual vs Executable

`framework-v2.md` alone is sufficient for manual adoption.

For repeatable execution across many repos, use:
1. `scripts/scaffold-collab.sh`
2. `collaboration-profile.yaml`

Recommended default for teams:
- Use manual mode for one-off setup
- Use script + profile for scaled/repeated onboarding and migration overlays

### Example commands

```bash
# Detect recommended mode from project state (always run first)
scripts/scaffold-collab.sh --mode auto --profile collaboration-profile.yaml --dry-run

# After user confirmation, run explicit mode
scripts/scaffold-collab.sh --mode <fresh|migrate> --profile collaboration-profile.yaml
```

---

## 21) History-Aware Migration Overlay

For existing projects with progress already made, migration should include:

1. Current-state scan
- Detect existing collaboration files and templates
- Detect branch naming patterns in repo history
- Detect validation style (manual/CI hints)

2. Drift report
- Compare existing setup against framework requirements
- List conflicts, missing artifacts, and likely policy collisions

3. Safe patch plan
- Preserve project-specific strengths
- Add missing governance controls
- Stage changes incrementally with rollback backup

Output recommendation:
- Write a migration audit report (for example `plans/collaboration-migration-audit.md`) before applying major policy changes

---

## 22) One-Folder Onboarding Experience (Recommended)

Desired operator flow:

1. Upload one framework folder to target repo
2. Ask Claude to read that folder
3. Claude auto-detects recommended mode from project state (`fresh` vs `migrate`)
4. Claude confirms mode choice with Human as one of the first questions
5. Claude runs a setup interview (project-tailoring questions)
6. Claude updates `collaboration-profile.yaml`
7. Claude runs scaffold in `--dry-run` first
6. Human approves
8. Claude applies scaffold and summarizes changes

### Fresh install path

1. Claude detects missing collaboration artifacts
2. Uses `scripts/scaffold-collab.sh --mode fresh`
3. Applies readiness checklist before first production task

### Migration overlay path

1. Claude detects existing collaboration artifacts/history
2. Uses `scripts/scaffold-collab.sh --mode migrate --dry-run`
3. Reviews migration audit with Human
4. Applies safe patch plan in phases

### Required behavior for Claude during onboarding

1. Ask tailoring questions before applying scaffold
2. Confirm mode choice (`fresh` vs `migrate`) with Human before apply
3. Never assume overwrite in existing repos without explicit approval
4. Surface conflicts against precedence rules
