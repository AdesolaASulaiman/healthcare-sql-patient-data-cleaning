-- CASE STUDY 1 | 05: Synthetic edge-case tests
-- Safe to share: all contact values below are fabricated test strings.
-- Read-only: does not query or modify public.patient or cleaning.patient_cleaned.
-- Tests the CURRENT parsing logic, not a redesigned parser.

WITH fixtures(test_id, scenario, contact_number, expected_main, expected_extension, expected_digits) AS (
    VALUES
      (1, 'Lowercase x extension', '020 1234 5678x123', '020 1234 5678', '123', '02012345678'),
      (2, 'Uppercase X extension', '020 1234 5678X45', '020 1234 5678', '45', '02012345678'),
      (3, 'No extension', '020-1234-5678', '020-1234-5678', NULL::text, '02012345678'),
      (4, 'Outer whitespace', ' 020 1234 5678x7 ', '020 1234 5678', '7', '02012345678'),
      (5, 'Missing contact', NULL::text, NULL::text, NULL::text, NULL::text),
      (6, 'Malformed x extension', '02012345678xABC', '02012345678xABC', NULL::text, '02012345678'),
      (7, 'Alternative ext notation', '02012345678 ext 9', '02012345678 ext 9', NULL::text, '020123456789'),
      (8, 'Plus sign and punctuation', '+44 (20) 1234-5678x12', '+44 (20) 1234-5678', '12', '442012345678')
),
parsed AS (
    SELECT f.*,
      CASE WHEN BTRIM(contact_number) ~* 'x[0-9]+$'
        THEN REGEXP_REPLACE(BTRIM(contact_number), 'x[0-9]+$', '', 'i')
        ELSE BTRIM(contact_number) END AS actual_main,
      CASE WHEN BTRIM(contact_number) ~* 'x[0-9]+$'
        THEN SUBSTRING(BTRIM(contact_number) FROM '[xX]([0-9]+)$')
        ELSE NULL END AS actual_extension
    FROM fixtures f
),
results AS (
    SELECT *, REGEXP_REPLACE(actual_main, '[^0-9]', '', 'g') AS actual_digits
    FROM parsed
)
SELECT
    test_id,
    scenario,
    CASE WHEN actual_main IS NOT DISTINCT FROM expected_main
           AND actual_extension IS NOT DISTINCT FROM expected_extension
           AND actual_digits IS NOT DISTINCT FROM expected_digits
      THEN 'PASS' ELSE 'FAIL' END AS parsing_test,
    CASE
      WHEN contact_number IS NULL THEN 'NOT_APPLICABLE'
      WHEN contact_number IS NOT DISTINCT FROM
        actual_main || CASE WHEN actual_extension IS NOT NULL THEN 'x' || actual_extension ELSE '' END
      THEN 'EXACT'
      ELSE 'NOT_EXACT'
    END AS reconstruction_with_lowercase_x,
    CASE WHEN actual_extension IS NULL AND contact_number ~* '(x|ext)\s*[^0-9]*$|ext\s*[0-9]+$'
      THEN 'REVIEW_EXTENSION_PATTERN'
      ELSE 'NO_FLAG_FROM_THIS_RULE'
    END AS extension_review_flag
FROM results
ORDER BY test_id;

-- Expected interpretation:
-- * All eight parsing tests should PASS against the current SQL expressions.
-- * Uppercase X and outer whitespace will not reconstruct byte-for-byte with
--   the original using the lowercase-x reconstruction expression.
-- * Malformed/alternative extension patterns are NOT correctly separated.
-- * NULL is handled without an exception; it should be flagged for review in
--   a production-quality policy.
-- Run in pgAdmin and record ACTUAL output before claiming test completion.
