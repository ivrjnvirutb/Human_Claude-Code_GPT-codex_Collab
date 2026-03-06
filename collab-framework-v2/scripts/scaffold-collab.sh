#!/usr/bin/env bash
set -euo pipefail

MODE="auto"
PROFILE="collaboration-profile.yaml"
FORCE="false"
DRY_RUN="false"

usage() {
  cat <<'USAGE'
Usage:
  scripts/scaffold-collab.sh [--mode auto|fresh|migrate] [--profile path] [--force] [--dry-run]

Modes:
  auto     Detect project state and recommend fresh or migrate (default)
  fresh    Initialize missing collaboration files for a new repo
  migrate  Preserve existing setup, create backup, and generate migration audit

Options:
  --mode      Setup mode (default: auto)
  --profile   Path to collaboration profile yaml (default: collaboration-profile.yaml)
  --force     Overwrite existing files (backs up in migrate mode)
  --dry-run   Print actions without writing files
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      MODE="${2:-}"
      shift 2
      ;;
    --profile)
      PROFILE="${2:-}"
      shift 2
      ;;
    --force)
      FORCE="true"
      shift
      ;;
    --dry-run)
      DRY_RUN="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ "$MODE" != "auto" && "$MODE" != "fresh" && "$MODE" != "migrate" ]]; then
  echo "Invalid --mode '$MODE'. Use auto, fresh, or migrate." >&2
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Run this script inside a git repository." >&2
  exit 1
fi

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

timestamp="$(date +%Y%m%d-%H%M%S)"
backup_dir=".collab-backup/${timestamp}"

log() {
  printf '%s\n' "$*"
}

detect_mode() {
  local score=0
  local reasons=""
  local collab_present=0
  local commits=0
  local branches=0

  local collab_files=(
    "AGENTS.md"
    "COLLABORATION.md"
    "MEMORY.md"
    "plans/KICKOFF_TEMPLATE.md"
    "plans/PLAN_TEMPLATE.md"
    "plans/PROMPT_TEMPLATE.txt"
    "plans/COMPLETION_GATE.md"
    "plans/automation-flags.md"
    "plans/collaboration-metrics.md"
  )

  for f in "${collab_files[@]}"; do
    if [[ -f "$f" ]]; then
      collab_present=$((collab_present + 1))
    fi
  done

  if [[ $collab_present -ge 1 ]]; then
    score=$((score + 2))
    reasons+="existing_collab_files=${collab_present}; "
  fi

  if [[ $collab_present -ge 3 ]]; then
    score=$((score + 1))
    reasons+="multiple_collab_files_present; "
  fi

  if [[ -d "plans/active" || -d "plans/completed" ]]; then
    score=$((score + 2))
    reasons+="plans_state_dirs_present; "
  fi

  commits="$(git rev-list --count HEAD 2>/dev/null || echo 0)"
  if [[ "$commits" =~ ^[0-9]+$ ]] && [[ "$commits" -ge 1 ]]; then
    score=$((score + 1))
    reasons+="commit_count=${commits}; "
  fi

  if [[ "$commits" =~ ^[0-9]+$ ]] && [[ "$commits" -ge 20 ]]; then
    score=$((score + 1))
    reasons+="mature_commit_history; "
  fi

  branches="$(git for-each-ref --format='%(refname:short)' refs/heads 2>/dev/null | wc -l | tr -d ' ')"
  if [[ "$branches" =~ ^[0-9]+$ ]] && [[ "$branches" -ge 3 ]]; then
    score=$((score + 1))
    reasons+="branch_count=${branches}; "
  fi

  if [[ -d ".github/workflows" ]]; then
    score=$((score + 1))
    reasons+="ci_workflows_present; "
  fi

  if [[ -z "$reasons" ]]; then
    reasons="no_strong_existing_collab_signals"
  fi

  if [[ $score -ge 3 ]]; then
    echo "migrate|$score|$reasons"
  else
    echo "fresh|$score|$reasons"
  fi
}

ensure_dir() {
  local d="$1"
  if [[ "$DRY_RUN" == "true" ]]; then
    log "[dry-run] mkdir -p $d"
  else
    mkdir -p "$d"
  fi
}

EFFECTIVE_MODE="$MODE"
if [[ "$MODE" == "auto" ]]; then
  IFS='|' read -r EFFECTIVE_MODE DETECT_SCORE DETECT_REASON <<< "$(detect_mode)"
  log "auto-detect recommendation: $EFFECTIVE_MODE (score=$DETECT_SCORE; $DETECT_REASON)"
  log "confirmation required: confirm mode with the user before apply."
  if [[ "$DRY_RUN" != "true" ]]; then
    log "no changes applied in auto mode."
    log "rerun with explicit mode after confirmation:"
    log "  scripts/scaffold-collab.sh --mode $EFFECTIVE_MODE --profile $PROFILE"
    exit 0
  fi
fi

write_file() {
  local path="$1"
  local content="$2"

  if [[ -f "$path" && "$FORCE" != "true" ]]; then
    log "skip existing: $path"
    return
  fi

  if [[ "$EFFECTIVE_MODE" == "migrate" && -f "$path" ]]; then
    ensure_dir "$backup_dir"
    if [[ "$DRY_RUN" == "true" ]]; then
      log "[dry-run] backup $path -> $backup_dir/$path"
    else
      ensure_dir "$(dirname "$backup_dir/$path")"
      cp "$path" "$backup_dir/$path"
    fi
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    log "[dry-run] write $path"
  else
    ensure_dir "$(dirname "$path")"
    printf '%s\n' "$content" > "$path"
    log "wrote: $path"
  fi
}

project_name="$(basename "$ROOT")"

if [[ ! -f "$PROFILE" ]]; then
  default_profile="project_name: \"$project_name\"
directory_model: \"same-directory\"
stage0_mode: \"dynamic\" # dynamic|required|disabled
validation_mode: \"manual\" # manual|ci|mixed
notebook_output_policy: \"preserve\" # preserve|clear
branch_naming:
  codex: \"codex/batchNN-short-name\"
  claude: \"claude/workflow-short-name\"
push_policy:
  codex_push: false
  claude_push_requires_human_approval: true
readme_update_cadence: \"milestone\"
automation_mode: \"disabled\"
memory_required: true
completion_gate_required: true
"
  write_file "$PROFILE" "$default_profile"
fi

agents_tpl="# ${project_name} — Agent Instructions

This file is the authoritative collaboration contract for this repository.

## Authority and Precedence
1. AGENTS.md
2. Active prompt
3. Active plan
4. Supporting docs

## Dynamic Step 0
Use complexity scoring to determine whether prompt refinement is required before planning.

## Roles
- Human: intent + acceptance
- Claude: planning/orchestration
- Codex: scoped implementation

## Scope Model
- Read Scope
- Write Scope
- Forbidden Scope

## BLOCKED protocol
Use hard-stop escalation for schema/scope/safety ambiguity.
"

collab_tpl="# Collaboration Guide

Project-specific collaboration nuances for Human, Claude, Codex.
AGENTS.md remains authoritative.
"

memory_tpl="# MEMORY

Concise persistent memory for stable decisions, risks, and pointers.
"

kickoff_tpl="# Session Kickoff Checklist

- [ ] Read MEMORY and active plans
- [ ] Confirm scope and success criteria
- [ ] Confirm validation method
- [ ] Confirm completion gate
"

plan_tpl="# [Task/Batch Name]

## Goal

## Context

## Read Scope

## Write Scope

## Forbidden Scope

## Implementation Guide

## Success Criteria

## Validation Method

## Risks & Ambiguities

## Handoff Notes
"

prompt_tpl="STEP 1: Sync repository state.
STEP 2: Read plan and context.
STEP 3: Implement only within Write Scope.
STEP 4: Commit to approved branch naming.
STEP 5: Return handoff artifact + review notes.
"

completion_tpl="# Completion Gate

A task can move from active to completed only when:
- [ ] Implementation evidence captured
- [ ] Validation status captured
- [ ] Review notes triaged
- [ ] Blockers resolved or logged
- [ ] Human confirmed close/archive decision
"

automation_tpl="# Automation Flags

Manual/automation triage log.
"

metrics_tpl="# Collaboration Metrics Log

## Weekly Log
| Week Of | Tasks Closed | BLOCKED | Avoidable BLOCKED | Rework Avg | Scope Drift | Handoff Completeness % | Gate First-Pass % | Notes |
|---------|--------------|---------|-------------------|------------|-------------|-------------------------|-------------------|-------|
"

rules_path=".codex/rules/${project_name}.rules"
rules_tpl="# ${project_name} Codex rules
prefix_rule(pattern=[\"git\", \"status\"], decision=\"allow\")
prefix_rule(pattern=[\"git\", \"diff\"], decision=\"allow\")
prefix_rule(pattern=[\"git\", \"reset\", \"--hard\"], decision=\"forbidden\")
"

write_file "AGENTS.md" "$agents_tpl"
write_file "COLLABORATION.md" "$collab_tpl"
write_file "MEMORY.md" "$memory_tpl"
write_file "plans/KICKOFF_TEMPLATE.md" "$kickoff_tpl"
write_file "plans/PLAN_TEMPLATE.md" "$plan_tpl"
write_file "plans/PROMPT_TEMPLATE.txt" "$prompt_tpl"
write_file "plans/COMPLETION_GATE.md" "$completion_tpl"
write_file "plans/automation-flags.md" "$automation_tpl"
write_file "plans/collaboration-metrics.md" "$metrics_tpl"
write_file "$rules_path" "$rules_tpl"

if [[ "$EFFECTIVE_MODE" == "migrate" ]]; then
  report="plans/collaboration-migration-audit.md"

  existing_files=(
    "AGENTS.md"
    "COLLABORATION.md"
    "MEMORY.md"
    "plans/KICKOFF_TEMPLATE.md"
    "plans/PLAN_TEMPLATE.md"
    "plans/PROMPT_TEMPLATE.txt"
    "plans/COMPLETION_GATE.md"
    "plans/automation-flags.md"
    "plans/collaboration-metrics.md"
    "$rules_path"
  )

  status_lines=""
  for f in "${existing_files[@]}"; do
    if [[ -f "$f" ]]; then
      status_lines+="- [present] $f\n"
    else
      status_lines+="- [missing] $f\n"
    fi
  done

  branch_prefixes="$(git for-each-ref --format='%(refname:short)' refs/heads | sed 's#/.*##' | sort | uniq -c | sort -nr | head -n 10 || true)"
  hotspots="$(git log --name-only --pretty=format: -n 200 | sed '/^$/d' | sort | uniq -c | sort -nr | head -n 20 || true)"

  ci_hint="absent"
  if [[ -d ".github/workflows" ]]; then
    ci_hint="present"
  fi

  audit="# Collaboration Migration Audit

Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)
Mode: migrate
Profile: $PROFILE

## 1) Existing collaboration artifacts
$status_lines
## 2) History signals

### Branch prefix usage (top)
\`\`\`
$branch_prefixes
\`\`\`

### File hotspot history (top)
\`\`\`
$hotspots
\`\`\`

### CI workflow directory
- .github/workflows: $ci_hint

## 3) Recommended migration actions

1. Preserve existing strengths; avoid full overwrite of mature docs.
2. Reconcile precedence and scope model in AGENTS first.
3. Add missing required artifacts only.
4. Pilot 1-2 tasks and tune thresholds using collaboration metrics.
"

  write_file "$report" "$audit"
fi

if [[ "$EFFECTIVE_MODE" == "migrate" && "$FORCE" == "true" ]]; then
  log "migration backups: $backup_dir"
fi

log "done: requested_mode=$MODE effective_mode=$EFFECTIVE_MODE profile=$PROFILE dry_run=$DRY_RUN force=$FORCE"
