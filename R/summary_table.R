make_summary_table <- function(foldsIndexResponse) {
    table = foldsIndexResponse |>
        distinct(patientunitstayid, .keep_all = TRUE) |>
        mutate(
            split = ifelse(fold != 2, "Training set", "Test set"),
            admitdiagnosis = forcats::fct_lump(admitdiagnosis, n = 5),
            ethnicity = ifelse(ethnicity == "", "Other/Unknown", ethnicity),
            admitdiagnosis = case_when(
                admitdiagnosis == "AMI" ~ "Acute myocardial infarction",
                admitdiagnosis == "S-CABG" ~ "Coronary artery bypass graft surgery",
                admitdiagnosis == "CHF" ~ "Chronic heart failure",
                admitdiagnosis == "UNSTANGINA" ~ "Unstable angina",
                admitdiagnosis == "HYPERTENS" ~ "Hypertension",
                TRUE ~ as.character(admitdiagnosis)
            )
        ) |>
        select(split, age, gender, height, weight, apachescore, admitdiagnosis, ethnicity) |>
        gtsummary::tbl_summary(
            statistic = list(
                age ~ "{mean} ({sd})",
                height ~ "{mean} ({sd})",
                weight ~ "{mean} ({sd})",
                apachescore ~ "{mean} ({sd})"
            ),
            by = split,
            sort = list(
                admitdiagnosis ~ "frequency",
                ethnicity ~ "frequency"
            ),
            label = list(
                age ~ "Age",
                gender ~ "Sex",
                height ~ "Height",
                weight ~ "Weight",
                apachescore ~ "APACHE score",
                admitdiagnosis ~ "Admission diagnosis",
                ethnicity ~ "Ethnicity"
            )
        ) |>
        gtsummary::add_overall()
        # gtsummary::as_gt(table)|>
        # gt::gtsave("summary_table.docx")

}
