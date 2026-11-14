# Healthcare Data Cleaning and Quality Assurance Using PostgreSQL

### Case Study 1: Patient Contact Number Cleaning and Standardisation

**Tools:** PostgreSQL | pgAdmin | SQL | Data Profiling | Data Cleaning | Data Quality Validation

**Dataset:** 30,000 patient records

**Project Status:** Completed and validated against the tested quality rules

---

## Project Overview

Reliable healthcare data begins with accurate and well-structured patient information. Even when a database has no missing values or duplicate identifiers, inconsistencies in how information is recorded can affect reporting, system integration and administrative processes.

In this project, I used PostgreSQL to investigate and standardise patient contact information in a healthcare database containing 30,000 records.

During the initial assessment, I identified 17,926 contact numbers (59.75%) containing characters outside the preliminary validation pattern.

Rather than immediately classifying these records as invalid, I investigated their structure and discovered that the affected numbers consistently used an `x` followed by digits to represent a telephone extension.

I developed a non-destructive SQL cleaning solution that separates the main telephone number from its extension while preserving the original value.

The final validation confirmed that all 30,000 patient records were retained, 17,926 extensions were extracted, and every original contact string could be reconstructed exactly.

## Key Project Results

| Performance Indicator | Verified Result |
|---|---:|
| Patient records assessed | 30,000 |
| Unique patient identifiers preserved | 30,000 |
| Contact numbers initially flagged | 17,926 |
| Percentage initially flagged | 59.75% |
| Telephone extensions extracted | 17,926 |
| Main telephone digit length after parsing | 10–13 |
| Records passing preliminary length validation | 30,000 |
| Original contact strings reconstructed exactly | 30,000 |
| Reconstruction mismatches | 0 |
| Invalid extracted extension formats | 0 |

**Key achievement:** I successfully separated 17,926 telephone extensions using PostgreSQL while preserving all 30,000 patient records and achieving zero reconstruction mismatches under the tested rules.

## Business Problem

Healthcare organisations depend on reliable contact information for patient communication, appointment administration and integration between information systems.

When telephone numbers and extensions are stored together, automated validation may incorrectly flag otherwise usable records.

The business question guiding this project was:

**How can patient contact information be standardised while maintaining data integrity and preserving the original records?**

My objectives were to:

- Assess patient data completeness, uniqueness and validity.
- Identify inconsistencies in contact-number formatting.
- Investigate the underlying causes of flagged records.
- Develop a reusable SQL cleaning transformation.
- Separate telephone extensions from main numbers.
- Validate the transformation using measurable quality checks.
- Document the methodology, findings and limitations.

## Explore the SQL Project

The following files contain the SQL scripts and documentation for this case study.

| Project File | Description |
|---|---|
| [01 — Patient Data Profiling](01_patient_profiling.sql) | Initial completeness, uniqueness and data-quality assessment |
| [02 — Category and Contact Diagnostics](02_category_and_contact_diagnostics.sql) | Investigation of demographic values and telephone-number patterns |
| [03 — SQL Cleaning Transformation](03_create_cleaned_patient_view.sql) | Creation of the cleaned patient view and telephone-extension extraction |
| [04 — Post-Cleaning Validation](04_post_cleaning_validation.sql) | Record preservation, format validation and reconstruction checks |
| [Results and Cleaning Log](results_and_cleaning_log.md) | Documented findings, cleaning decisions and validation outcomes |

## Repository Structure

The current GitHub repository contains the following files:

```text
healthcare-sql-patient-data-cleaning/
│
├── README.md
│
├── 01_patient_profiling.sql
├── 02_category_and_contact_diagnostics.sql
├── 03_create_cleaned_patient_view.sql
├── 04_post_cleaning_validation.sql
│
└── results_and_cleaning_log.md
```

The scripts are organised numerically to make the analytical workflow easy to follow.

## Dataset Description

The analysis used the `public.patient` table from a PostgreSQL healthcare database.

| Column | Description |
|---|---|
| `patient_id` | Unique patient identifier |
| `gender` | Recorded patient gender |
| `date_of_birth` | Patient date of birth |
| `blood_group` | Recorded blood group |
| `city` | Patient city |
| `contact_number` | Original patient contact information |

The original dataset contained 30,000 patient records.

To protect data integrity, I performed the cleaning in a separate PostgreSQL schema rather than modifying the source table.

## Methodology

### Step 1 — Data Profiling

I began by assessing the structure and quality of the patient table using SQL queries.

The profiling process included:

- Missing-value checks using `IS NULL`.
- Duplicate detection using `COUNT(DISTINCT)`.
- Date-of-birth validity checks.
- Category consistency analysis.
- Whitespace checks using `BTRIM`.
- Contact-number length and character analysis.

**Findings:**

The patient table contained 30,000 unique patient identifiers, with no missing values in the assessed fields.

The initial checks also identified no future birth dates, birth dates implying ages over 120, or leading and trailing whitespace in the tested text fields.

These findings provided a reliable starting point for further analysis.

### Step 2 — Contact Number Quality Assessment

I used SQL regular expressions and string functions to identify contact numbers containing unexpected characters or unusual lengths.

The investigation identified:

- 17,926 records containing characters outside the initial screening pattern.
- 4,821 contact numbers containing more than 15 numeric digits when extensions were included.
- Contact strings ranging from 10 to 22 characters.

These results suggested potential formatting inconsistencies but did not establish that the telephone numbers were invalid.

### Step 3 — Root Cause Investigation

I examined the patterns responsible for the validation exceptions.

Further analysis showed that the 17,926 flagged records consistently used the `x`-extension format.

The main telephone-number portions contained between 10 and 13 digits.

This indicated that the initial screening was flagging a recognised extension convention rather than necessarily identifying incorrect telephone information.

**Key lesson:** An unusual format is not automatically a data error. Effective data cleaning requires understanding the underlying pattern before applying transformations.

### Step 4 — SQL Data Cleaning and Standardisation

I created a reusable PostgreSQL view:

`cleaning.patient_cleaned`

The transformation separated the original contact information into structured fields.

| Output Field | Purpose |
|---|---|
| `contact_number` | Preserves the original contact string |
| `main_phone_original` | Retains the main telephone portion before the extension |
| `main_phone_digits` | Provides a digits-only representation of the main number |
| `phone_extension` | Stores the extracted extension digits |
| `phone_quality_status` | Records the preliminary format-validation outcome |

The transformation used:

- Common Table Expressions (CTEs).
- `CASE` expressions.
- `REGEXP_REPLACE`.
- `SUBSTRING`.
- `BTRIM`.
- PostgreSQL views.
- Conditional data-quality rules.

The original patient records were not overwritten or deleted.

### Step 5 — Post-Cleaning Validation

After creating the cleaned view, I executed SQL validation queries to confirm that the transformation preserved the data correctly.

The validation checked:

1. Total records retained.
2. Unique patient identifiers.
3. Telephone extensions extracted.
4. Main telephone digit lengths.
5. Preliminary format-validation results.
6. Exact reconstruction of original contact strings.
7. Invalid extension formats.

All 30,000 records passed the preliminary main-number length check.

A separate reconstruction test confirmed that all 30,000 original contact strings could be reconstructed exactly from the parsed components, with zero mismatches.

This demonstrated that the transformation preserved the original contact information under the tested reconstruction rule.

## Before-and-After Data Quality Assessment

| Quality Measure | Before Cleaning | After Cleaning |
|---|---|---|
| Patient records | 30,000 | 30,000 retained |
| Unique patient identifiers | 30,000 | 30,000 preserved |
| Composite phone and extension values | 17,926 | Extensions separated |
| Main phone number field | Not separately available | Structured digits-only field |
| Extension field | Not separately available | 17,926 extracted |
| Main phone length validation | Not independently assessed | 30,000 passed |
| Exact reconstruction | Not applicable | 30,000 matched |
| Information loss | Not assessed | Zero reconstruction mismatches |

The before-and-after checks measure different aspects of data quality. The results demonstrate successful parsing and structural standardisation, not independent verification that every telephone number is genuine or reachable.

## Business Value

This project demonstrates how SQL can improve the structure and usability of healthcare administrative data.

**Improved data structure:** Main telephone numbers and extensions are available as separate fields, supporting downstream processing.

**Reduced false validation alerts:** Recognised extension notation is handled explicitly instead of being automatically treated as invalid.

**Preserved data integrity:** The original contact information remains available for auditing and verification.

**Reproducible cleaning:** The PostgreSQL view can be reused when the underlying patient table is queried.

**Evidence-based decision-making:** Cleaning rules were developed after investigating the source of the formatting exceptions.

## Technical Skills Demonstrated

| Skill | Application |
|---|---|
| SQL and PostgreSQL | Database querying and transformation |
| Data Profiling | Completeness, uniqueness and format checks |
| Data Cleaning | Telephone-number parsing and standardisation |
| Data Quality Assurance | Validation of transformed records |
| Regular Expressions | Pattern detection and extension extraction |
| Common Table Expressions | Organising multi-stage transformations |
| SQL Views | Creating reusable, non-destructive data outputs |
| Data Integrity | Source preservation and reconstruction testing |
| Root Cause Analysis | Investigating initial validation exceptions |
| Data Validation | Quantifying post-transformation outcomes |
| Technical Documentation | Recording methods, results and limitations |

## How to Reproduce the Project

1. Install PostgreSQL and pgAdmin.
2. Load an authorised healthcare dataset containing a compatible `public.patient` table.
3. Review the profiling and diagnostic SQL scripts.
4. Execute the cleaning transformation script.
5. Create the `cleaning.patient_cleaned` view.
6. Run the post-cleaning validation script.
7. Compare the results with the documented cleaning log.

The scripts were curated from the completed PostgreSQL workflow and should be rerun against the source database when independently reproducing the project.

No raw patient contact data or database credentials are included in this repository.

## Challenges and Lessons Learned

The most significant challenge was distinguishing genuine data-quality problems from expected formatting conventions.

The initial screening identified 17,926 potentially problematic records, which appeared to indicate a widespread formatting issue.

However, the investigation showed that these records followed a consistent telephone-extension pattern.

Instead of deleting or replacing the values, I designed a transformation that separated their components while retaining the original information.

This experience strengthened my practical understanding of data profiling, SQL transformation, root-cause analysis, data integrity and quality validation.

It also reinforced the importance of testing cleaning outcomes rather than assuming that a transformation has worked correctly.

## Project Limitations

This project uses a healthcare demonstration dataset whose real-world provenance has not been independently verified.

The telephone-number validation focuses on structural formatting and digit lengths. It does not verify telephone-number ownership, reachability or compliance with country-specific numbering plans.

The documented reconstruction test establishes exact preservation under the tested extension convention. Further checks may be required for other telephone-number formats.

The results represent the completed case-study workflow and should not be interpreted as a certified assessment of a live healthcare organisation.

## Conclusion

This project demonstrates my ability to use PostgreSQL to investigate data-quality issues, develop practical SQL cleaning solutions and validate transformation results.

By combining data profiling, regular-expression analysis, non-destructive transformation and post-cleaning validation, I improved the structure of 30,000 patient contact records while preserving their original information.

The project forms **Case Study 1 of my Healthcare Data Quality Engineering Portfolio**.

Future case studies will examine hospital admission integrity, billing reconciliation, insurance policy validation and hospital bed-assignment consistency.

---

**Core Skills:** SQL | PostgreSQL | Healthcare Data Analytics | Data Cleaning | Data Quality Assurance | Data Profiling | Data Transformation | Data Validation | Data Integrity | Data Standardisation | Root Cause Analysis | Database Management
