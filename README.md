# Claude + Codex Collaboration Framework v2

Portable collaboration template for people who want a more reliable Human + Claude + Codex workflow without needing a complex setup first.

## What This Repo Is

This public GitHub repo is intentionally minimal.

It contains:

- this `README.md`
- the `collab-framework-v2/` folder

That is the entire public release surface by design.

The goal is simple:

- let curious users open the repo and read the raw framework files directly
- let non-technical users download one folder manually
- let them start a fresh Claude Code session and follow a guided setup path

## Recommended Install Path

This is the main path most users should follow.

1. Download this repo from GitHub.
2. Copy `collab-framework-v2/` into the root of the repo you want to work on.
3. Start a new Claude Code session inside that target repo.
4. Ask Claude to read `collab-framework-v2/START_HERE.md`.
5. Let Claude guide the setup step by step.

This approach is meant to feel inspectable and low-friction. You can read the files first, understand what the framework does, and then install it manually.

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

## What’s Inside `collab-framework-v2/`

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

## What Each File Does

- `framework-v2.md`: the actual methodology and operating model
- `START_HERE.md`: the one-file onboarding instruction for a new Claude Code session
- `collaboration-profile.yaml`: the project-specific configuration template
- `scripts/scaffold-collab.sh`: the setup script that handles `auto`, `fresh`, and `migrate`
- `README.md` inside the folder: a short quick-start for the portable bundle

## What The Framework Adds

- clear Human, Claude, and Codex roles
- a contract hierarchy with `AGENTS.md` as the source of truth
- dry-run-first setup
- support for both new repos and existing repos
- scoped execution boundaries
- BLOCKED escalation rules
- completion gates and collaboration hygiene

## Fresh vs Migrate

- `fresh`: for a new repo or a repo that does not already have a mature collaboration structure
- `migrate`: for an existing repo where current docs, habits, or governance need to be preserved and upgraded carefully

The framework is built so migration does not blindly overwrite mature project docs.

## Who This Is For

- people starting to formalize a Claude Code workflow
- teams that want cleaner Human, Claude, and Codex handoffs
- users who want a reusable collaboration template across multiple repos

## Advanced Install

Users who already know how to work with npm can install the packaged skill directly with:

```bash
npx @rookfolio/collab-framework-skill install --project
```

That path is intended for advanced users who want tighter skill-based integration rather than a manual folder install.

## License

MIT. See [collab-framework-v2/LICENSE](/Users/lar/librAIry/collab-framework-v2/LICENSE).
