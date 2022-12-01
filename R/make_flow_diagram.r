make_flow_diagram <- function(dataModel,
                              foldsIndexResponse,
                              joinedTables,
                              nitro,
                              data_formatted) {
    all_titrations <- data_formatted |>
        group_by(id) |>
        distinct(n_nitro, .keep_all = T) |>
        na.omit() |>
        nrow()

    titration_60_30 <- dataModel |>
        nrow()

    all_nitro <- nitro |>
        distinct(patientunitstayid) |>
        nrow()
    nitro_bp <- joinedTables |>
        distinct(patientunitstayid) |>
        nrow()
    patients_60_30 <- dataModel |>
        distinct(patientunitstayid) |>
        nrow()
    patients_multiple <- foldsIndexResponse |>
        distinct(patientunitstayid) |>
        nrow()

    hospitals <- foldsIndexResponse |>
        distinct(hospitalid) |>
        nrow()
    titrations <- foldsIndexResponse |>
        nrow()


    return(tribble(
        ~info, ~patients,
        "All patients", all_nitro,
        "Patients with blood pressure", nitro_bp,
        "Patients with blood pressure and age between 60 and 30", patients_60_30,
        "Number of hospitals", hospitals,
        "Titrations", titrations
    ))
}
