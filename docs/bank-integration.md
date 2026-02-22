# Bank integration roadmap (automatic payment ingestion)

This document proposes a safe way to add bank integration to Monity so incoming payments can be imported automatically.

## 1) Integration model

Use a **provider adapter** architecture in the data layer:

- `BankConnector` (domain contract)
- One implementation per provider (`PluggyConnector`, `BelvoConnector`, etc.)
- `BankSyncService` (application orchestration)

Why: It keeps provider-specific API details isolated and matches the project's clean architecture style.

## 2) New domain concepts

Add core entities:

- `BankAccount` (providerAccountId, bankName, accountNumberMasked, balance)
- `BankConnection` (userId, provider, status, consentExpiresAt)
- `BankPayment`/`BankTransaction` (externalId, amount, date, description, direction)

Also add **idempotency key** fields, so the same bank event is not imported twice.

## 3) Persistence changes (SQLite)

Add tables:

- `bank_connections`
- `bank_accounts`
- `bank_transactions`

And update existing `transactions` with metadata columns:

- `externalId TEXT`
- `source TEXT` (`manual` | `bank_sync`)
- `bankConnectionId INTEGER`

Create indexes for `(externalId, source)` to deduplicate fast.

## 4) Sync flow

1. User links bank account (OAuth/Open Finance consent).
2. App stores encrypted provider tokens (never plaintext in DB).
3. Background sync fetches transactions from provider.
4. Mapper converts provider model -> internal `Transaction`.
5. Upsert by `externalId` + account id.
6. Recompute home/dashboard summaries.

## 5) Security and compliance

- Keep secrets in secure storage (`flutter_secure_storage`), not in normal SQLite rows.
- Add explicit consent screens and disconnection flow.
- Log only masked account information.
- Respect LGPD/GDPR data deletion requests.

## 6) Suggested incremental rollout

### Phase 1

- Manual CSV import for one bank (validates mapping + dedup strategy).

### Phase 2

- Real provider integration for read-only account + transactions.

### Phase 3

- Scheduled background sync + sync status in UI.

### Phase 4

- Multi-bank support + reconciliation rules.

## 7) UI additions

- New "Connected banks" page in settings/profile.
- "Connect bank" CTA.
- Last sync timestamp and sync errors.
- Toggle for "Auto-import incoming payments".

## 8) Backend recommendation

For production, prefer using a backend (API + webhook endpoint) between app and bank providers.

Reason:

- Better secret management
- Webhook handling reliability
- Centralized retries + audit trail

Mobile app can still support local mode for development, but server-side orchestration is safer.
