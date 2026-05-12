// ─── Content ─────────────────────────────────────────────────────────────────

export type ContentType = 'text' | 'code' | 'art' | 'audio' | 'video';

// ─── Certificate ─────────────────────────────────────────────────────────────

export interface Certificate {
  /** BytesN<32> as hex string */
  id: string;
  /** SHA-256 hex of the certified content */
  contentHash: string;
  /** did:stellar:G... */
  humanDID: string;
  contentType: ContentType;
  /** Unix timestamp */
  issuedAt: number;
  /** Unix timestamp — present only if revoked */
  revokedAt?: number;
}

// ─── Verification ─────────────────────────────────────────────────────────────

export interface VerificationResult {
  certified: boolean;
  certificate?: Certificate;
  error?: string;
}

// ─── ZK Proof ────────────────────────────────────────────────────────────────

export interface ZKProof {
  pi_a: string[];
  pi_b: string[][];
  pi_c: string[];
  publicSignals: string[];
}

// ─── Oracle ──────────────────────────────────────────────────────────────────

export type ProviderCode = 'persona' | 'jumio' | 'stripe';

export interface AttestationReceipt {
  /** One-time nonce — prevents replay attacks on the zk circuit */
  nonce: string;
  /** Unix timestamp */
  timestamp: number;
  /** Identity provider that performed verification */
  providerCode: ProviderCode;
  /** Poseidon(nonce, timestamp, providerCode) — no PII */
  commitment: string;
  /** Oracle ECDSA signature (BabyJubJub) over commitment */
  signature: {
    r: string;
    s: string;
  };
}

// ─── Network ─────────────────────────────────────────────────────────────────

export type Network = 'mainnet' | 'testnet';
