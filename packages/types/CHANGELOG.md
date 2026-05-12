# Changelog — @humonics/types

## 0.1.0 — 2026-05-12

### Added
- `ContentType` — `'text' | 'code' | 'art' | 'audio' | 'video'`
- `Certificate` — core certificate shape with `id`, `contentHash`, `humanDID`, `contentType`, `issuedAt`, `revokedAt?`
- `VerificationResult` — `certified`, `certificate?`, `error?`
- `ZKProof` — groth16 proof shape with `pi_a`, `pi_b`, `pi_c`, `publicSignals`
- `AttestationReceipt` — oracle receipt with nonce, commitment, BabyJubJub signature
- `ProviderCode` — `'persona' | 'jumio' | 'stripe'`
- `Network` — `'mainnet' | 'testnet'`
