-- Case Study 1 | 04: Post-cleaning validation (read-only)
SELECT COUNT(*) AS total_cleaned_records,
       COUNT(DISTINCT patient_id) AS unique_patient_ids,
       COUNT(*) FILTER (WHERE phone_extension IS NOT NULL) AS extensions_extracted,
       COUNT(*) FILTER (WHERE phone_quality_status = 'FORMAT_PASSED') AS format_passed,
       COUNT(*) FILTER (WHERE phone_quality_status = 'REVIEW_REQUIRED') AS review_required,
       MIN(LENGTH(main_phone_digits)) AS minimum_main_digits,
       MAX(LENGTH(main_phone_digits)) AS maximum_main_digits
FROM cleaning.patient_cleaned;

-- Verify lossless reconstruction of original strings, including extension notation
SELECT COUNT(*) AS total_records,
       COUNT(*) FILTER (
           WHERE contact_number = main_phone_original ||
               CASE WHEN phone_extension IS NOT NULL THEN 'x' || phone_extension ELSE '' END
       ) AS exactly_reconstructed,
       COUNT(*) FILTER (
           WHERE contact_number IS DISTINCT FROM main_phone_original ||
               CASE WHEN phone_extension IS NOT NULL THEN 'x' || phone_extension ELSE '' END
       ) AS reconstruction_mismatches,
       COUNT(*) FILTER (WHERE phone_extension IS NOT NULL AND phone_extension !~ '^[0-9]+$')
           AS invalid_extension_formats
FROM cleaning.patient_cleaned;
