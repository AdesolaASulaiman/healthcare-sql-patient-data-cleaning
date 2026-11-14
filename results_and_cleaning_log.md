# Data cleaning log and verified results

All counts below were reported from pgAdmin screenshots in the completed case study. They have not been independently recalculated against the database here.

| Stage | Observation | Decision |
|---|---|---|
| Baseline profiling | 30,000 records; 0 missing/duplicate ID excess; 0 missing tested fields; 0 future/over-120 birth dates; 0 outer-whitespace flags | No source changes required for tested rules |
| Demographic category validation | 8 ABO/Rh groups; Male 15,918, Female 13,478, Other 604 | Preserve recorded categories |
| Contact screening | 17,926 flagged by unexpected-character rule; 4,821 with >15 total digits | Investigate rather than delete |
| Pattern diagnosis | 17,926 `X_EXTENSION`; 12,074 `NO_LETTER_EXTENSION` | Parse main number and extension separately |
| Cleaning view | 30,000 records retained; 17,926 extensions extracted; main digits 10–13 | Use non-destructive `cleaning.patient_cleaned` view |
| Post-cleaning screen | 30,000 `FORMAT_PASSED`; 0 `REVIEW_REQUIRED` | Preliminary length screen passed; not proof of telephone validity |
| Exact reconstruction | 30,000 exact matches; 0 mismatches; 0 invalid extension formats | Tested transformation is lossless |

## Cleaning rationale

The source column stores both main numbers and extension suffixes. The initial screening rule excluded the character `x`, while total digit counting included extension digits. These rules were useful for anomaly detection but did not establish invalid telephone numbers. Parsing the components separately makes the data easier to analyse and validate without discarding original information.

## Safeguards

- Source `public.patient` is not modified.
- Patient IDs and original contact strings are retained in the view for traceability.
- No contact numbers are published in this repository.
- Contact length is a preliminary structural check only.
- Geographic and real-world phone-number validity remain out of scope.
