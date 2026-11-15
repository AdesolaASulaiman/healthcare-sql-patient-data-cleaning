# Healthcare Data Quality Engineering | PostgreSQL

**Case Study 1 — Patient Contact Number Cleaning and Validation**  
**Tools:** PostgreSQL · SQL · pgAdmin · CTEs · Regular Expressions · Data Quality Testing

## Project summary

I investigated telephone-number formatting across **30,000 patient records**. An initial screening rule flagged **17,926 records (59.75%)**. Instead of discarding them, I traced the exceptions to a consistent `x`-extension convention and built a **non-destructive PostgreSQL view** that separates the main number and extension while retaining the source value.

| Verified measure | Result |
|---|---:|
| Patient records / unique IDs | 30,000 / 30,000 |
| Initially flagged contact records | 17,926 (59.75%) |
| Extensions extracted | 17,926 |
| Main-number lengths after parsing | 10–13 digits |
| Records passing the preliminary 7–15-digit length check | 30,000 |
| Original contact strings reconstructed exactly | 30,000 |
| Reconstruction mismatches | 0 |

**Result:** The view produces separately usable contact fields without updating `public.patient`. Exact reconstruction verifies preservation under the tested source-data convention; it does **not** verify that telephone numbers are active, reachable or valid under a country's numbering plan.

## Business problem and approach

Composite phone-and-extension fields can trigger false alarms in simple format checks and complicate downstream processing. My goal was to understand the exceptions before changing the representation.

1. **Profile:** Check completeness, patient-ID uniqueness, dates, categories and contact formats.
2. **Diagnose:** Use SQL regular expressions to identify the `x`-extension pattern behind the flagged records.
3. **Transform:** Create `cleaning.patient_cleaned` using CTEs, `CASE`, `SUBSTRING`, `BTRIM` and `REGEXP_REPLACE`.
4. **Validate:** Compare record counts, extracted extensions and reconstructed contact strings with the originals.

The cleaned view retains `contact_number` and adds `main_phone_original`, `main_phone_digits`, `phone_extension` and `phone_quality_status`. The current `FORMAT_PASSED` label means **only** that the main number contains 7–15 digits; it is not a full telephone-number validation.

## SQL scripts and documentation

| File | What it demonstrates |
|---|---|
| [01 — Patient profiling](01_patient_profiling.sql) | Completeness, uniqueness and baseline quality checks |
| [02 — Contact diagnostics](02_category_and_contact_diagnostics.sql) | Investigation of unexpected contact-number patterns |
| [03 — Cleaning view](03_create_cleaned_patient_view.sql) | Non-destructive parsing and standardisation |
| [04 — Validation](04_post_cleaning_validation.sql) | Preservation and reconstruction checks |
| [Cleaning log](results_and_cleaning_log.md) | Decisions, results and limitations |
| [05 — Synthetic edge-case tests](05_synthetic_edge_case_tests.sql) | Additional proposed tests using fabricated values; **run locally before reporting outcomes** |

## pgAdmin execution evidence

These are links to the screenshots uploaded to this repository. They show aggregate query outputs rather than individual patient contact details.

| Evidence | What to verify |
|---|---|
| [01 — Patient profiling](01_patient_data_profiling.PNG) | Record counts and missing-value checks |
| [02 — Format diagnostics](02_contact_format_diagnostics.PNG) | Initially flagged records and extension pattern |
| [03 — Reconstruction validation](03_phone_reconstruction_validation.PNG) | Exact reconstructions and mismatch count |
| [04 — Standardisation consistency](04_phone_standardisation_validation.PNG) | Digits-only transformation consistency; interpret from the actual screenshot |

## Repository structure

```text
healthcare-sql-patient-data-cleaning/
├── README.md
├── 01_patient_profiling.sql
├── 02_category_and_contact_diagnostics.sql
├── 03_create_cleaned_patient_view.sql
├── 04_post_cleaning_validation.sql
├── 05_synthetic_edge_case_tests.sql       # add with this update
├── results_and_cleaning_log.md
├── 01_patient_data_profiling.PNG
├── 02_contact_format_diagnostics.PNG
├── 03_phone_reconstruction_validation.PNG
└── 04_phone_standardisation_validation.PNG
```

## How to run

1. Connect pgAdmin to a PostgreSQL database with a compatible `public.patient` table. The source dataset is **not** distributed here.
2. Run the scripts `01` through `04` in order. Script `03` creates the `cleaning` schema and view without changing the source table.
3. Run `05_synthetic_edge_case_tests.sql` separately. It uses only fabricated values and does not access patient data.
4. Compare your aggregate results with the [cleaning log](results_and_cleaning_log.md) and screenshot evidence.

## Engineering judgement and limitations

The key decision was to **investigate before cleaning**: 17,926 initial exceptions reflected an extension convention, not proven invalid numbers. Separating fields can make subsequent processing more predictable, but no measured improvement in communication success, processing time or cost is claimed.

The source dataset's real-world provenance has not been independently verified. The current transformation recognises a trailing `x`/`X` followed by digits; malformed or alternative extension formats require separate handling. The view trims outer whitespace, and reconstruction results should not be generalised beyond the tested source records. The synthetic test script demonstrates additional scenarios but is **not evidence of production behaviour until executed and reviewed**.

**Skills demonstrated:** SQL, PostgreSQL, data profiling, data cleaning, regular expressions, CTEs, data quality assurance, data validation, root-cause analysis and technical documentation.

**Next case study:** Hospital admissions—date consistency, referential integrity and length-of-stay validation.
