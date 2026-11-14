-- Case Study 1 | 02: Category and contact diagnostics (read-only)
SELECT 'Gender' AS field_name, gender AS recorded_value, COUNT(*) AS total_records
FROM public.patient GROUP BY gender
UNION ALL
SELECT 'Blood Group', blood_group, COUNT(*) FROM public.patient GROUP BY blood_group
ORDER BY field_name, total_records DESC, recorded_value;

SELECT
    COUNT(DISTINCT city) AS distinct_cities,
    COUNT(DISTINCT LOWER(BTRIM(city))) AS normalised_distinct_cities,
    COUNT(DISTINCT contact_number) AS distinct_contact_numbers,
    COUNT(*) FILTER (WHERE contact_number !~ '^[0-9+() .-]+$') AS contacts_with_unexpected_characters,
    MIN(LENGTH(contact_number)) AS minimum_contact_length,
    MAX(LENGTH(contact_number)) AS maximum_contact_length,
    COUNT(*) FILTER (WHERE LENGTH(REGEXP_REPLACE(contact_number, '[^0-9]', '', 'g')) < 7) AS contacts_under_7_digits,
    COUNT(*) FILTER (WHERE LENGTH(REGEXP_REPLACE(contact_number, '[^0-9]', '', 'g')) > 15) AS contacts_over_15_digits
FROM public.patient;

-- Aggregate pattern diagnostics: no patient-level values exposed
WITH phone_patterns AS (
    SELECT contact_number,
        CASE
            WHEN contact_number ~* 'x[0-9]+$' THEN 'X_EXTENSION'
            WHEN contact_number ~* '(ext\.?|extension)[[:space:]]*[0-9]+$' THEN 'TEXT_EXTENSION'
            WHEN contact_number ~ '[A-Za-z]' THEN 'OTHER_LETTERS'
            ELSE 'NO_LETTER_EXTENSION'
        END AS phone_pattern,
        LENGTH(REGEXP_REPLACE(SPLIT_PART(LOWER(contact_number), 'x', 1), '[^0-9]', '', 'g')) AS digits_before_x
    FROM public.patient
)
SELECT phone_pattern, COUNT(*) AS total_records,
       ROUND(100.0 * COUNT(*) / NULLIF(SUM(COUNT(*)) OVER (), 0), 2) AS percentage,
       MIN(LENGTH(contact_number)) AS minimum_length,
       MAX(LENGTH(contact_number)) AS maximum_length,
       MIN(digits_before_x) AS minimum_digits_before_x,
       MAX(digits_before_x) AS maximum_digits_before_x
FROM phone_patterns
GROUP BY phone_pattern
ORDER BY total_records DESC;
