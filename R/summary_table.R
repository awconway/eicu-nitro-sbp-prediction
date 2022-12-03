make_summary_table <- function(foldsIndexResponse) {
    table <- foldsIndexResponse |>
        distinct(patientunitstayid, .keep_all = TRUE) |>
        mutate(
            split = ifelse(fold != 2, "Training set", "Test set"),
            admitdiagnosis = forcats::fct_lump(admitdiagnosis, n = 5),
            unitType = forcats::fct_lump(unitType, n = 3),
            ethnicity = ifelse(ethnicity == "", "Other/Unknown", ethnicity),
            admitdiagnosis = case_when(
                admitdiagnosis == "AMI" ~ "Acute myocardial infarction",
                admitdiagnosis == "S-CABG" ~ "Coronary artery bypass graft surgery",
                admitdiagnosis == "CHF" ~ "Chronic heart failure",
                admitdiagnosis == "UNSTANGINA" ~ "Unstable angina",
                admitdiagnosis == "HYPERTENS" ~ "Hypertension",
                TRUE ~ as.character(admitdiagnosis)
            ),
            unitType = case_when(
                unitType == "Med-Surg ICU" ~ "Medical-Surgical Intensive Care Unit",
                unitType == "CCU-CTICU" ~ "Coronary Care Unit/Cardiothoracic Intensive Care Unit",
                unitType == "Cardiac ICU" ~ "Cardiac Intensive Care Unit",
            )
        ) |>
        select(split, age, gender, ethnicity, height, weight, apachescore, unitType, admitdiagnosis) |>
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
                ethnicity ~ "frequency",
                unitType ~ "frequency"
            ),
            label = list(
                age ~ "Age",
                gender ~ "Sex",
                height ~ "Height",
                weight ~ "Weight",
                apachescore ~ "APACHE score",
                admitdiagnosis ~ "Admission diagnosis",
                ethnicity ~ "Ethnicity",
                unitType ~ "Unit type"
            )
        ) |>
        gtsummary::add_overall()
    # gtsummary::as_gt(table)|>
    # gt::gtsave("summary_table.docx")
}
