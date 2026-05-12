# Changelog — @humonics/types

## 0.1.1 — 2026-05-12

### Changed
- `VerificationResult` — replaced `{ certified, certificate?, error? }` struct with
  `{ status: 'certified' | 'not_certified' | 'revoked', certificate? }` to match the
  on-chain Soroban enum shape. Soroban `#[contracttype]` cannot nest `Option<ContractType>`
  in a struct; the enum is the correct on-chain representation.
- Added `VerificationResultStatus` type alias.

## 0.1.0 — 2026-05-12

### Added
- `ContentType` — `'text' | 'code' | 'art' | 'audio' | 'video'`
- `Certificate` — core certificate shape with `id`, `contentHash`, `humanDID`, `contentType`, `issuedAt`, `revokedAt?`
- `VerificationResult` — `certified`, `certificate?`, `error?`
- `ZKProof` — groth16 proof shape with `pi_a`, `pi_b`, `pi_c`, `publicSignals`
- `AttestationReceipt` — oracle receipt with nonce, commitment, BabyJubJub signature
- `ProviderCode` — `'persona' | 'jumio' | 'stripe'`
- `Network` — `'mainnet' | 'testnet'`
