-- Case Study 1 | 01: Source data profiling (read-only)
SELECT
    COUNT(*) AS total_patients,
    COUNT(DISTINCT patient_id) AS unique_patient_ids,
    COUNT(*) FILTER (WHERE patient_id IS NULL) AS missing_patient_ids,
    COUNT(*) - COUNT(DISTINCT patient_id) AS duplicate_or_null_id_excess,
    COUNT(*) FILTER (WHERE gender IS NULL OR BTRIM(gender) = '') AS missing_gender,
    COUNT(*) FILTER (WHERE date_of_birth IS NULL) AS missing_date_of_birth,
    COUNT(*) FILTER (WHERE date_of_birth > CURRENT_DATE) AS future_birth_dates,
    COUNT(*) FILTER (WHERE date_of_birth < CURRENT_DATE - INTERVAL '120 years') AS age_over_120,
    COUNT(*) FILTER (WHERE blood_group IS NULL OR BTRIM(blood_group) = '') AS missing_blood_group,
    COUNT(*) FILTER (WHERE city IS NULL OR BTRIM(city) = '') AS missing_city,
    COUNT(*) FILTER (WHERE contact_number IS NULL OR BTRIM(contact_number) = '') AS missing_contact_number,
    COUNT(*) FILTER (WHERE gender <> BTRIM(gender) OR blood_group <> BTRIM(blood_group)
       OR city <> BTRIM(city) OR contact_number <> BTRIM(contact_number)) AS records_with_extra_spaces
FROM public.patient;
