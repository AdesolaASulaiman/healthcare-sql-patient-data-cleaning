-- Case Study 1 | 03: Non-destructive cleaning view
-- This creates a schema/view; it does NOT update the source patient table.
CREATE SCHEMA IF NOT EXISTS cleaning;

CREATE OR REPLACE VIEW cleaning.patient_cleaned AS
WITH parsed AS (
    SELECT p.*,
        CASE WHEN BTRIM(contact_number) ~* 'x[0-9]+$'
             THEN REGEXP_REPLACE(BTRIM(contact_number), 'x[0-9]+$', '', 'i')
             ELSE BTRIM(contact_number) END AS main_phone_original,
        CASE WHEN BTRIM(contact_number) ~* 'x[0-9]+$'
             THEN SUBSTRING(BTRIM(contact_number) FROM '[xX]([0-9]+)$')
             ELSE NULL END AS phone_extension
    FROM public.patient p
), standardised AS (
    SELECT *, REGEXP_REPLACE(main_phone_original, '[^0-9]', '', 'g') AS main_phone_digits
    FROM parsed
)
SELECT patient_id, gender, date_of_birth, blood_group, city, contact_number,
       main_phone_original, main_phone_digits, phone_extension,
       CASE WHEN LENGTH(main_phone_digits) BETWEEN 7 AND 15
            THEN 'FORMAT_PASSED' ELSE 'REVIEW_REQUIRED' END AS phone_quality_status
FROM standardised;
