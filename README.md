# healthcare-sql-patient-data-cleaning
PostgreSQL healthcare data cleaning portfolio demonstrating patient contact number profiling, extension extraction, standardisation, and lossless validation across 30,000 records.
# Healthcare Data Cleaning and Quality Assurance Using PostgreSQL

### Case Study 1: Patient Contact Number Cleaning and Standardisation

**Tools:** PostgreSQL | pgAdmin | SQL | Data Cleaning | Data Profiling | Data Quality Validation

**Project Type:** Healthcare Data Analytics Portfolio

**Dataset:** 30,000 Patient Records

## Project Overview

Accurate patient information is essential for effective healthcare administration, communication and reliable data analysis. However, even when a database appears complete, inconsistencies in how information is recorded can affect its usefulness.

In this project, I used PostgreSQL to investigate and improve the structure of patient contact information in a hospital database containing 30,000 records.

My initial data-quality assessment showed that patient identifiers were unique, key demographic fields were complete, and no obvious date or whitespace problems were present.

However, further investigation revealed that 17,926 contact numbers, representing 59.75% of the dataset, contained characters outside the initial telephone-format screening rules.

Rather than immediately deleting or replacing these values, I investigated the underlying cause.

I discovered that the affected records consistently contained telephone extensions written using the letter `x` followed by additional digits.

This finding became the foundation for a practical SQL data-cleaning solution.

## Business Problem

Healthcare organisations rely on accurate contact information for appointment coordination, patient communication and administrative processes.

When telephone numbers and extensions are stored together in one field, they can create problems for data validation, system integration and reporting.

The main business question was:

**How can patient contact numbers be standardised without losing important information or changing the original records?**

My objectives were to:

- Assess the completeness, uniqueness and consistency of patient records.
- Identify potentially invalid or inconsistent telephone-number formats.
- Investigate the causes of formatting exceptions.
- Separate telephone numbers from extensions using SQL.
- Preserve the original data for auditing and traceability.
- Validate the accuracy and completeness of the transformation.

## Dataset Description

The analysis used the `patient` table from a PostgreSQL healthcare database.

| Column | Description |
|---|---|
| patient_id | Unique patient identifier |
| gender | Recorded patient gender |
| date_of_birth | Patient date of birth |
| blood_group | Recorded blood group |
| city | Patient city |
| contact_number | Patient contact information |

The dataset contained 30,000 patient records.

The original table was preserved throughout the cleaning process. A separate PostgreSQL schema was used to store the cleaned data view.

## My Approach

### 1. Data Profiling and Quality Assessment

I started by examining the structure and content of the patient table.

Using PostgreSQL queries, I assessed missing values, duplicate identifiers, date validity, demographic categories and whitespace inconsistencies.

The initial assessment confirmed:

- 30,000 unique patient identifiers.
- No missing values in the assessed fields.
- No future birth dates or birth dates implying ages over 120.
- No leading or trailing whitespace in the tested text fields.
- Consistently labelled gender and blood group categories.

These results showed that the dataset had strong foundational quality, but further investigation was needed to assess telephone-number formatting.

### 2. Identifying Contact Number Inconsistencies

I used SQL regular expressions and string functions to examine contact-number patterns.

The analysis identified:

- 17,926 contact numbers containing characters outside the initial screening pattern.
- 4,821 contact numbers containing more than 15 numeric digits when extensions were included.
- Contact strings ranging from 10 to 22 characters.

Instead of treating these records as invalid, I examined the formatting patterns more closely.

### 3. Investigating the Root Cause

Further SQL analysis showed that all 17,926 flagged contact numbers followed an `x`-extension pattern.

This explained why the initial validation had flagged so many records.

The problem was not necessarily incorrect telephone information. It was that the main telephone number and extension were stored together.

This investigation reinforced an important lesson from the project: **data-quality issues should be understood before cleaning rules are applied.**

### 4. Implementing the SQL Cleaning Solution

I created a reusable PostgreSQL view named:

`cleaning.patient_cleaned`

The view separates the contact information into structured fields:

| Field | Purpose |
|---|---|
| contact_number | Preserves the original value |
| main_phone_original | Stores the main number before the extension |
| main_phone_digits | Stores the main number in digits-only format |
| phone_extension | Stores the extracted extension |
| phone_quality_status | Records the preliminary format-validation result |

I used Common Table Expressions (CTEs), `CASE` statements, `REGEXP_REPLACE`, `SUBSTRING` and conditional logic to implement the transformation.

The solution was non-destructive. No original patient records were updated or deleted.

### 5. Post-Cleaning Validation

After creating the cleaned view, I performed additional SQL checks to verify that the transformation worked correctly.

The validation focused on record preservation, identifier uniqueness, extension extraction, main-number length and exact reconstruction of the original contact strings.

## Results and Key Achievements

| Performance Indicator | Verified Result |
|---|---:|
| Patient records processed | 30,000 |
| Unique patient IDs preserved | 30,000 |
| Contact extensions identified and extracted | 17,926 |
| Main telephone digit lengths | 10–13 |
| Records passing preliminary length validation | 30,000 |
| Original contact strings reconstructed exactly | 30,000 |
| Reconstruction mismatches | 0 |
| Invalid extracted extension formats | 0 |

**Key achievement:** Successfully separated 17,926 telephone extensions while retaining all 30,000 patient records and achieving 100% exact reconstruction under the tested rules.

The transformation improved the structure of the contact information without removing or overwriting the original data.

The validation confirms structural consistency and preservation of information; it does not independently verify that the telephone numbers are active or reachable.

## SQL Skills Demonstrated

This project demonstrates practical experience in:

- **SQL Data Cleaning:** Preparing and standardising data for analysis.
- **Data Profiling:** Identifying patterns, inconsistencies and potential data-quality issues.
- **Data Quality Assurance:** Testing completeness, uniqueness, validity and consistency.
- **PostgreSQL:** Writing and executing SQL queries in pgAdmin.
- **Common Table Expressions (CTEs):** Organising multi-stage transformations.
- **Regular Expressions:** Identifying and extracting telephone-number patterns.
- **Data Transformation:** Creating structured fields from composite text values.
- **Data Validation:** Confirming transformation accuracy using SQL checks.
- **Root Cause Analysis:** Investigating why records failed initial quality rules.
- **Data Integrity:** Preserving source records and validating transformed outputs.
- **Exception Handling:** Distinguishing genuine data issues from expected formatting conventions.
- **Technical Documentation:** Recording methodology, results and analytical limitations.

## Business Value

This project demonstrates how SQL can improve the usability and reliability of healthcare administrative data.

By separating main telephone numbers and extensions, the cleaned dataset provides more structured information for downstream applications.

The approach also reduces the risk of incorrectly rejecting records simply because their formatting differs from an initial validation rule.

Most importantly, the project demonstrates a controlled data-cleaning process in which the original information remains available for verification.

## Project Files

The repository contains the SQL scripts and supporting documentation used for the case study.

```text
healthcare-patient-contact-cleaning/
│
├── README.md
│
├── sql/
│   ├── 01_patient_profiling.sql
│   ├── 02_category_and_contact_diagnostics.sql
│   ├── 03_create_cleaned_patient_view.sql
│   └── 04_post_cleaning_validation.sql
│
└── docs/
    └── results_and_cleaning_log.md
```

### How to Reproduce the Analysis

1. Set up PostgreSQL and pgAdmin.
2. Load an authorised dataset containing the required `public.patient` table.
3. Run the SQL scripts in numerical order.
4. Create the cleaned patient view in the `cleaning` schema.
5. Execute the validation queries.
6. Compare the results with the documented findings.

The repository does not include raw patient contact information or database credentials.

## Challenges and Lessons Learned

One of the most valuable lessons from this project was understanding the difference between an unusual data format and an actual data error.

At first, the large number of flagged contact records suggested a significant data-quality problem.

However, deeper investigation revealed that the records followed a consistent telephone-extension convention.

By investigating before transforming, I was able to develop a solution that preserved the original information while improving its structure.

This experience strengthened my understanding of SQL data profiling, root-cause analysis, data integrity and validation.

## Project Limitations

The analysis was conducted using a healthcare demonstration dataset whose real-world provenance has not been independently verified.

Telephone-number validation was limited to structural formatting and digit lengths. Country-specific numbering rules, ownership and reachability were not assessed.

The SQL scripts are documented reconstructions of the completed PostgreSQL workflow and should be rerun against the source database when reproducing the project.

## Conclusion

This case study demonstrates my ability to use PostgreSQL to investigate data-quality issues, develop practical SQL transformations and validate the results.

By combining data profiling, root-cause analysis, non-destructive cleaning and post-transformation testing, I produced a more structured patient contact dataset while preserving all original records.

The project forms the first part of my wider **Healthcare Data Quality Engineering Portfolio**, which will also cover hospital admissions, billing reconciliation, insurance records and bed-assignment integrity.

---

**Core Competencies:** SQL | PostgreSQL | Healthcare Data Analytics | Data Cleaning | Data Quality Assurance | Data Validation | Data Transformation | Data Integrity | Data Profiling | Data Standardisation | Root Cause Analysis | Database Management
