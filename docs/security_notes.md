# Security Notes

Security, privacy and data-handling decisions for this project, with the checks that support them.

---

# Data Classification

| Item | Classification | Notes |
|------|----------------|-------|
| Cookie Cats dataset | Public | Published on Kaggle. Contains a numeric player ID, the test group, a round count and two retention flags; no names, contact details or other direct identifiers (verified in Phase 1). A player ID can still be a persistent identifier, so the absence of names does not by itself mean the data is fully anonymised. Not committed to the repository |
| Project configuration (`.env`) | Internal | Google Cloud project ID, dataset name and location. Not secret, but kept out of the repository; `.env.example` shows the variable names |
| Google Cloud credentials | Confidential | Application Default Credentials stored in `~/.config/gcloud`, outside the repository. No service account key file exists |

---

# Sensitive Information Review

Checked on 2026-10-16 by searching the full history of every branch on GitHub (`main` and `phase-0-scoping`) for common secret patterns (passwords, API keys, tokens, private keys, client secrets) and listing every file ever committed. No matches were found and no credential, `.env` or data file appears in the history. A pattern search cannot guarantee that every possible secret has been detected.

- [x] No passwords committed
- [x] No API keys committed
- [x] No database credentials committed
- [x] No access tokens committed
- [x] No confidential client data committed (portfolio project, no client)
- [x] Personally identifiable information (PII) reviewed (2026-10-16: the five fields contain no names, contact details or other direct identifiers)
- [ ] Dataset anonymisation confirmed where required (cannot be confirmed: whether `userid` links to real player accounts is not stated. The data is not redistributed)

Rechecked on 2026-10-25 before making the repository public, over the full history of every local and remote branch. Every match for the secret patterns was checklist wording in this file, `.env` was never tracked, and no credential or raw data file appears in the history.

---

# Environment Configuration

- [x] `.env` file created
- [x] `.env` included in `.gitignore` and confirmed ignored with `git check-ignore`
- [x] Configuration loaded with `python-dotenv`; no secrets are stored in `.env`
- [x] Local environment tested (BigQuery listed datasets and ran a query from Python)

---

# Repository Security

- [x] `.gitignore` verified, including credential file patterns (`*service-account*.json`, `*credentials*.json`, `*-key.json`)
- [x] Raw and processed data paths covered by `.gitignore` (`data/raw/*`, `data/processed/*`), and no data files are tracked. `.gitignore` only stops untracked files from being added, so staged files are still checked before each commit
- [x] Processed data reviewed before commit (no processed data files are committed; the clean table exists only in BigQuery)
- [x] Large files kept out of the repository
- [x] Dataset licence requirements reviewed (2026-10-16: listed as Unknown on Kaggle)
- [x] Repository is not nested inside another Git repository (verified after removing a home-folder repository; see phase_00_setup.md)

---

# Data Usage & Licensing

| Dataset | License / Usage Terms | Compliant |
|----------|-----------------------|-----------|
| Cookie Cats A/B test (Kaggle: `yufengsui/mobile-games-ab-testing`, originally from DataCamp project 184) | Listed as "Unknown" on Kaggle (checked 2026-10-16). No usage terms are granted on the listing | Used for non-commercial portfolio analysis only, with the source credited. The data is not redistributed through this repository; readers download it from the source themselves |

The repository's MIT licence covers the project's code and documentation only, not the dataset.

---

# Security Risks

| Risk | Potential Impact | Mitigation | Status |
|------|------------------|------------|--------|
| A credential file is committed | Anyone with repository access could use the Google Cloud project | Application Default Credentials are used without a service account key file. Credential file patterns are covered by `.gitignore`. Staged files are reviewed before each push | Mitigated |
| `.env` is committed | Configuration exposed | `.env` in `.gitignore`, confirmed with `git check-ignore` | Mitigated |
| Files outside the project are pushed by mistake | Private files from the home folder could reach GitHub | The home-folder Git repository was disconnected; this project is confirmed not nested | Resolved. The backup folder `~/old-home-git-backup` can be deleted once no longer needed |
| Unexpected cloud charges | Costs to the author | Billing was disabled on the project in the Google Cloud console, so no billing account is linked and BigQuery runs in the sandbox. Recheck if the project configuration changes | Mitigated |
| The dataset is redistributed against its licence | Breach of the dataset's terms | Data folders are excluded from Git. The licence is listed as Unknown, so the data is used for non-commercial portfolio analysis only and not redistributed | Mitigated |
| Repository made public with unreviewed history | Anything ever committed becomes visible | The full history of every branch was scanned on 2026-10-25 before the visibility change. See Sensitive Information Review | Mitigated |