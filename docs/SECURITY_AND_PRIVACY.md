# Security and Privacy Specification

## 1. Security posture

This product handles highly sensitive personal information: financial transactions, account metadata, tasks, routines, notes, activity history, and potentially SMS/notification content.

Security and privacy are product requirements, not post-release hardening tasks.

## 2. Core principles

- local-first by default
- collect the minimum data required
- retain the minimum sensitive raw data required
- encrypt sensitive persisted data where practical
- do not expose secrets through logs, analytics, backups, screenshots, or crash reports
- require explicit opt-in for cloud features that move private data off-device
- prefer deterministic on-device processing for sensitive classification where practical
- fail closed for integrity-sensitive operations

## 3. Threat model

Primary threats include:

- lost or stolen unlocked device
- malicious app/process on a compromised/rooted device
- leaked backup archive
- accidental logging/telemetry disclosure
- exposed Git/API credentials during development
- insecure cloud sync/backup implementation
- malicious or compromised remote parser-rule source
- screenshot/recent-app preview leakage
- unauthorized use by someone with temporary physical access
- data corruption mistaken for valid financial history

The project does not claim to fully secure data on a fully compromised operating system. It should, however, avoid making compromise unnecessarily easy.

## 4. Local database protection

Direction:

- protect database secrets with Android Keystore-backed key material
- evaluate a Room-compatible encrypted SQLite approach before implementation
- never hardcode encryption keys
- never derive encryption keys from predictable device/user values alone
- document key-loss implications before release

Exact library/implementation requires an ADR once the Android scaffold is selected.

## 5. Application lock

Target capability:

- biometric authentication where supported
- app PIN fallback/option
- configurable auto-lock timeout
- require re-authentication for sensitive operations as appropriate

App-lock state must not be confused with cryptographic database key management.

## 6. SMS and notification privacy

Raw financial messages are sensitive.

Default architecture should:

1. receive/observe the source event
2. parse locally
3. extract the minimum required fields
4. retain a fingerprint/hash and parser metadata where useful
5. avoid indefinitely retaining full raw message text unless required by an explicit feature/debug option

Non-financial personal SMS must never be uploaded as a side effect of financial parsing.

## 7. Permissions

Request permissions only when a feature genuinely needs them and explain the user value before the system prompt.

The app must remain useful if sensitive permissions such as SMS access are denied.

Capture architecture therefore supports multiple sources rather than making one permission the entire product.

## 8. Sensitive logging ban

Production logs/telemetry must not include, by default:

- raw SMS/notification text
- full card/account/IBAN numbers
- complete transaction descriptions that may identify people
- balances
- transaction amounts
- task/note content
- location content
- PINs/authentication values
- encryption keys
- access/refresh tokens

Use IDs, event types, parser versions, coarse error categories, and privacy-safe counters instead.

## 9. Redaction

If a diagnostic export includes potentially sensitive identifiers, use deliberate redaction such as:

- last 4 digits only where necessary
- stable local pseudonymous IDs
- explicit user confirmation before creating an expanded diagnostic package

Never assume truncation is sufficient for all sensitive text.

## 10. Analytics

Analytics must be optional/configured to avoid private content.

Useful privacy-safe events may include:

- feature opened
- parser success/failure category
- backup operation success/failure
- crash type
- anonymous performance duration buckets

Do not send transaction values, user notes, merchant names, or personal task titles merely to improve product analytics.

## 11. Crash reporting

Crash reporting must be audited for automatic breadcrumbs, request payloads, database values, and exception messages that might contain sensitive information.

A crash SDK is not safe merely because the SDK vendor claims compliance.

## 12. Backup security

Backups containing private data must be encrypted before leaving the app's trust boundary.

Backup design must define:

- encryption scheme/version
- key ownership/recovery model
- integrity authentication
- schema version
- checksum/metadata
- restore validation
- corrupted/wrong-key behavior

Cloud backup provider storage must not be treated as encryption by itself.

## 13. Restore safety

Never overwrite the user's valid current data before an imported backup has passed:

- decryption/authentication
- integrity validation
- format/schema compatibility checks
- structural validation

Where feasible, preserve a recovery snapshot before destructive restore replacement.

## 14. Remote parser rules

Remote parser updates are a supply-chain boundary.

Requirements:

- signed/authenticated rule packages
- explicit version
- rollback support
- schema validation
- constrained declarative format
- no arbitrary script/code execution
- safe fallback to bundled rules

A compromised rule server must not become arbitrary code execution on the device.

## 15. Network security

When network features exist:

- TLS only
- no cleartext production endpoints
- validate endpoint configuration
- minimize transmitted data
- define retry/idempotency behavior
- never silently fall back to insecure transport

Certificate pinning, if considered, requires an ADR because operational key rotation risks are significant.

## 16. Secrets in repository

Never commit:

- GitHub/API tokens
- OAuth client secrets where actually confidential
- private signing keys
- Android release keystores
- production `.env` secrets
- backup encryption secrets
- real user data

Use `.gitignore`, secret scanning, CI checks, and external secret storage suitable to the toolchain.

If a secret appears in Git history, deleting the line in a later commit is insufficient: rotate/revoke the credential first.

## 17. Screenshot and recent-app privacy

Consider user-configurable protection for sensitive screens:

- hide/blur content in recent-app thumbnails
- optional screenshot blocking for finance/private-history screens
- privacy mode masking amounts/content

Do not force screenshot blocking globally if it harms legitimate user workflows without strong benefit.

## 18. Clipboard

Avoid automatically placing sensitive values in the clipboard.

When a user explicitly copies sensitive information, consider platform-supported mechanisms to mark sensitive clipboard content and minimize persistence where available.

## 19. Export security

Exports can intentionally reduce protection.

Before CSV/Excel/PDF/JSON export:

- explain that the output may be unencrypted
- let the user control what is included
- avoid hidden extra private fields
- never include raw source content unless explicitly requested

## 20. Authentication/cloud sync future

Do not build account authentication simply because “apps have accounts”.

If multi-device sync is introduced later, define:

- identity model
- encryption model
- conflict resolution
- device revocation
- key recovery
- data deletion
- offline behavior
- server trust assumptions

through dedicated ADR/specs before implementation.

## 21. Development/debug builds

Debug tooling must not leak into release builds.

Production release verification should check:

- debug endpoints disabled
- test credentials absent
- verbose sensitive logging disabled
- WebView/debuggable settings appropriate
- exported Android components intentional
- backup/debug flags intentional

## 22. Dependencies

Every new dependency expands supply-chain risk.

Before adding a dependency, consider:

- maintenance/activity
- license
- permissions
- transitive dependencies
- data collection/telemetry
- whether the standard library/platform already solves the need

Security-sensitive dependencies require explicit review.

## 23. Security incident rule

If a credential, private user dataset, signing key, or sensitive backup is exposed:

1. stop normal feature work
2. revoke/rotate affected secrets
3. contain public access
4. document the incident without reproducing secrets
5. assess Git/history/cache exposure
6. add prevention/verification if possible
7. only then resume feature work

## 24. Privacy-preserving diagnostics goal

A support engineer should normally be able to diagnose “parser version X failed on source type Y with error category Z” without seeing the user's actual bank message, balance, or personal note.
