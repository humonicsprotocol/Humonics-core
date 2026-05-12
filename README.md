# Humonics Core

The monorepo root for the Humonics protocol. Shared types, configs, CI workflows, and bootstrap scripts. No application logic lives here.

---

## What's in here

```
packages/
├── types/    # @humonics/types — shared TypeScript types for all repos
└── config/   # @humonics/config — shared ESLint, TSConfig, Prettier

scripts/
├── setup-repos.sh   # Clone all org repos
└── bootstrap.sh     # Full local dev setup (clone + install + Redis)

.github/workflows/
├── ci.yml             # Reusable: lint + typecheck + test
├── soroban-deploy.yml # Reusable: deploy Soroban contracts
└── sdk-publish.yml    # Reusable: npm publish on release tag
```

---

## Quick start

```bash
git clone git@github.com:humonicsprotocol/Humonics-core.git
cd Humonics-core
chmod +x scripts/*.sh
./scripts/bootstrap.sh    # clones all repos, installs deps, starts Redis
```

---

## Packages

### `@humonics/types`

Canonical TypeScript types shared across all Humonics repos. Every sub-repo imports from here — types are never duplicated.

```typescript
import type {
  Certificate,
  VerificationResult,
  ZKProof,
  AttestationReceipt,
  ContentType,
  ProviderCode,
  Network,
} from '@humonics/types';
```

**Adding a new type:**
1. Add to `packages/types/src/index.ts`
2. Bump patch version in `packages/types/package.json`
3. Add entry to `packages/types/CHANGELOG.md`
4. Rebuild: `npm run build -w packages/types`

### `@humonics/config`

Shared tooling configs. Sub-repos extend these instead of maintaining their own.

```jsonc
// tsconfig.json in any server repo
{ "extends": "@humonics/config/tsconfig.base.json" }

// tsconfig.json in SDK / browser packages
{ "extends": "@humonics/config/tsconfig.esm.json" }
```

```jsonc
// package.json
{ "prettier": "@humonics/config/prettier.config.js" }
```

---

## CI workflows (reusable)

All sub-repos call these via `workflow_call`. They are never triggered directly.

### `ci.yml` — lint + typecheck + test

```yaml
# In any sub-repo's .github/workflows/ci.yml:
jobs:
  ci:
    uses: humonicsprotocol/Humonics-core/.github/workflows/ci.yml@main
    with:
      node-version: '20'
```

### `soroban-deploy.yml` — deploy contracts to testnet/mainnet

```yaml
jobs:
  deploy:
    uses: humonicsprotocol/Humonics-core/.github/workflows/soroban-deploy.yml@main
    with:
      network: testnet
      contract-name: certificate_registry
    secrets:
      STELLAR_SECRET_KEY: ${{ secrets.STELLAR_SECRET_KEY }}
      SOROBAN_RPC_URL: ${{ secrets.SOROBAN_RPC_URL }}
```

### `sdk-publish.yml` — publish to npm on release tag

```yaml
jobs:
  publish:
    uses: humonicsprotocol/Humonics-core/.github/workflows/sdk-publish.yml@main
    secrets:
      NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

---

## Repo map

| Repo | Purpose |
|---|---|
| [Humonics-core](https://github.com/humonicsprotocol/Humonics-core) | This repo — shared types, configs, CI |
| [Humonics-sdk](https://github.com/humonicsprotocol/Humonics-sdk) | TypeScript SDK — `@humonics/sdk` |
| [Humonics-api](https://github.com/humonicsprotocol/Humonics-api) | REST API gateway |
| [Humonics-oracle-service](https://github.com/humonicsprotocol/Humonics-oracle-service) | Identity attestation oracle |
| [Humonics-dashboard](https://github.com/humonicsprotocol/Humonics-dashboard) | Web app (Next.js) |

---

## Rules

- All shared types go in `packages/types` — never duplicate in sub-repos
- Config changes must be validated against all sub-repos before merging
- Scripts must be idempotent — running twice must not break anything
- Never commit `.env` files or secrets
- Work on `develop`, PR to `main`, never push directly to `main`
