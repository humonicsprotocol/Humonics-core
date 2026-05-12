# Contributing to Humonics Core

## What lives here

Shared TypeScript types (`packages/types`), shared configs (`packages/config`), reusable CI workflows, and bootstrap scripts. No application logic.

## Local setup

```bash
git clone git@github.com:humonicsprotocol/Humonics-core.git
cd Humonics-core
npm install
npm run build
```

## Rules

- **All shared types go in `packages/types`** — never duplicate them in sub-repos
- **Config changes must be validated against all sub-repos** before merging
- **Scripts must be idempotent** — running twice must not break anything
- **Never commit `.env` files or secrets**

## Adding a shared type

1. Add to `packages/types/src/index.ts`
2. Bump patch version in `packages/types/package.json`
3. Add entry to `packages/types/CHANGELOG.md`
4. Rebuild: `npm run build -w packages/types`

## Branch naming

`feat/`, `fix/`, `chore/`, `docs/` — PRs target `main`.
