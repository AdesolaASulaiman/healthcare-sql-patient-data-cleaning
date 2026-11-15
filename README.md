# Healthcare Data Quality Engineering | PostgreSQL

### Case Study 1: Patient Contact Number Cleaning and Validation

**Tools:** PostgreSQL, pgAdmin, SQL, Regular Expressions, Common Table Expressions (CTEs)

**Focus:** Healthcare Data Analytics | Data Cleaning | Data Quality Assurance | Data Validation

## Project at a Glance

I used PostgreSQL to investigate and standardise patient contact information across 30,000 healthcare records.

My initial data-quality checks identified 17,926 contact numbers (59.75%) containing characters outside the preliminary validation pattern. Further investigation revealed that these records used a consistent telephone-extension convention.

Rather than deleting or replacing the flagged records, I developed a non-destructive SQL transformation that separates main telephone numbers from their extensions while retaining the original information.

### Key Results

| Metric | Result |
|---|---:|
| Patient records analysed | 30,000 |
| Unique patient IDs preserved | 30,000 |
| Initially flagged contact records | 17,926 (59.75%) |
| Telephone extensions extracted | 17,926 |
| Records passing preliminary main-number length checks | 30,000 |
| Original contact strings reconstructed exactly | 30,000 |
| Reconstruction mismatches | 0 |
| Invalid extracted extension formats | 0 |

**Outcome:** All 30,000 original contact strings were preserved under the tested reconstruction rule, and the extracted telephone information became available in separate, structured fields.

## Business Problem

Healthcare organisations rely on reliable patient information for communication, administration and data integration.

Telephone numbers containing extensions may fail basic format checks even when their information is usable.

The aim of this project was to answer:

**How can patient contact information be standardised without losing data or changing the original patient records?**

I focused on three priorities: identifying the actual cause of formatting exceptions, creating a repeatable cleaning process and verifying the transformation.

## SQL Scripts and Documentation

| File | Description |
|---|---|
| [01 — Patient Data Profiling](01_patient_profiling.sql) | Completeness, uniqueness, date and formatting checks |
| [02 — Contact Format Diagnostics](02_category_and_contact_diagnostics.sql) | Analysis of contact-number patterns and extensions |
| [03 — SQL Cleaning Transformation](03_create_cleaned_patient_view.sql) | Creates the cleaned patient view using PostgreSQL |
| [04 — Post-Cleaning Validation](04_post_cleaning_validation.sql) | Tests record preservation and reconstruction accuracy |
| [Results and Cleaning Log](results_and_cleaning_log.md) | Findings, decisions and validation documentation |

## Data Cleaning Methodology

### 1. Data Profiling

I started by assessing the `public.patient` table, which contained 30,000 records.

Using SQL, I checked:

- Missing and duplicate patient identifiers.
- Missing demographic and contact values.
- Date-of-birth validity.
- Category consistency.
- Leading and trailing whitespace.
- Telephone-number formatting patterns.

The initial assessment confirmed 30,000 unique patient identifiers and no missing values in the assessed fields.

### 2. Root Cause Investigation

The initial contact-number screening identified 17,926 records containing unexpected characters.

I investigated these records using regular expressions and string functions.

The analysis showed that the flagged records consistently used an `x` followed by digits to represent a telephone extension.

This was an important finding: the records were not necessarily invalid. The problem was that the main telephone number and extension were stored together.

### 3. Data Transformation

I created a PostgreSQL view named:

`cleaning.patient_cleaned`

The view contains the original patient fields alongside additional structured contact fields.

| Output Field | Purpose |
|---|---|
| `contact_number` | Original contact information |
| `main_phone_original` | Main telephone portion before the extension |
| `main_phone_digits` | Digits-only main telephone number |
| `phone_extension` | Extracted extension |
| `phone_quality_status` | Preliminary length-based format status |

The transformation uses CTEs, `CASE`, `REGEXP_REPLACE`, `SUBSTRING` and `BTRIM`.

The original `public.patient` table remains unchanged.

### 4. Data Quality Validation

I validated the cleaning process by comparing the transformed output against the original information.

The tests confirmed that:

- All 30,000 patient records were retained.
- All 17,926 recognised extensions were extracted.
- All 30,000 original contact strings could be reconstructed exactly.
- No reconstruction mismatches were detected.
- No invalid extracted extension formats were detected.

These results demonstrate successful parsing and preservation under the tested rules. They do not establish that every telephone number is active, reachable or compliant with a specific country's numbering plan.

## PostgreSQL Execution Evidence

The following screenshots document the pgAdmin queries and outputs used to assess the cleaning process.

### Evidence 1 — Patient Data Profiling

![Patient data profiling in pgAdmin](01_patient_data_profiling.PNG)

[Open profiling screenshot](01_patient_data_profiling.PNG)

This evidence documents the initial patient-record and completeness checks.

### Evidence 2 — Contact Format Diagnostics

![Contact format diagnostics in pgAdmin](02_contact_format_diagnostics.PNG)

[Open contact diagnostics screenshot](02_contact_format_diagnostics.PNG)

This evidence documents the investigation of initially flagged contact-number formats and extension patterns.

### Evidence 3 — Reconstruction Validation

![Telephone reconstruction validation in pgAdmin](03_phone_reconstruction_validation.PNG)

[Open reconstruction screenshot](03_phone_reconstruction_validation.PNG)

This evidence documents the validation of reconstructed contact strings against their original values.

### Evidence 4 — Standardisation Consistency

![Telephone standardisation consistency in pgAdmin](04_phone_standardisation_validation.PNG)

[Open standardisation screenshot](04_phone_standardisation_validation.PNG)

This evidence documents the supplementary check comparing the digits-only telephone field with the recalculated standardised value.

## Repository Structure

The project files are currently organised as follows:

```text
healthcare-sql-patient-data-cleaning/
├── README.md
├── 01_patient_profiling.sql
├── 02_category_and_contact_diagnostics.sql
├── 03_create_cleaned_patient_view.sql
├── 04_post_cleaning_validation.sql
├── results_and_cleaning_log.md
├── 01_patient_data_profiling.PNG
├── 02_contact_format_diagnostics.PNG
├── 03_phone_reconstruction_validation.PNG
└── 04_phone_standardisation_validation.PNG
```

## Technical Skills Demonstrated

| Skill | Application |
|---|---|
| PostgreSQL and SQL | Data querying, transformation and validation |
| Data Profiling | Assessing completeness, uniqueness and consistency |
| Regular Expressions | Identifying and extracting telephone extensions |
| Common Table Expressions | Structuring multi-stage SQL transformations |
| Data Cleaning | Separating and standardising composite contact fields |
| Data Quality Assurance | Checking transformed data against expected rules |
| Data Integrity | Preserving original records and validating reconstruction |
| Root Cause Analysis | Investigating why records failed initial screening |
| Technical Documentation | Recording methodology, results and limitations |

## How to Reproduce the Analysis

1. Install PostgreSQL and pgAdmin.
2. Connect to a database containing a compatible `public.patient` table.
3. Run `01_patient_profiling.sql`.
4. Run `02_category_and_contact_diagnostics.sql`.
5. Run `03_create_cleaned_patient_view.sql` to create the cleaned view.
6. Run `04_post_cleaning_validation.sql`.
7. Compare the outputs with the documented results.

The source dataset is not distributed in this repository. Reproducing the exact figures requires access to the original or an equivalent dataset.

## Business Value and Lessons Learned

This project improved the structure of patient contact information while preserving the original records.

Separating telephone extensions creates cleaner fields for downstream processing and reduces the risk of incorrectly rejecting records based on an overly restrictive initial format rule.

The most important lesson was that **effective data cleaning begins with understanding the data, not automatically changing it**.

The project also reinforced the importance of non-destructive transformations, measurable validation checks and transparent documentation.

## Limitations and Data Privacy

The dataset is used for healthcare analytics demonstration purposes; its real-world provenance has not been independently verified.

The validation checks structural formatting and information preservation, not telephone-number ownership or reachability.

Only SQL scripts, documentation and aggregate pgAdmin evidence are intended for publication. Patient-level contact information and database credentials should not be shared.

## Next Steps

This project is the first case study in my wider Healthcare Data Quality Engineering Portfolio.

Planned areas of analysis include hospital admission integrity, billing reconciliation, insurance policy validation and hospital bed-assignment consistency.

---

**Core Competencies:** SQL | PostgreSQL | Healthcare Data Analytics | Data Cleaning | Data Profiling | Data Quality Assurance | Data Validation | Data Transformation | Data Integrity | Root Cause Analysis
