get_data <- function() {
    write_csv(
        query_cols(
            connection = eicu_conn,
            table = "patient",
            columns = "patientunitstayid,
       age,
       apacheadmissiondx,
       ethnicity,
       gender,
       admissionheight,
       admissionweight,
       unitAdmitSource,
       uniquepid,
       hospitalid"
        ),
        "data/patient.csv"
    )

    patient <- read_csv("data/patient.csv")

    write_csv(
        query_rows(
            connection = eicu_conn,
            table = "infusiondrug",
            columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
            rows = "drugname = 'Nitroglycerin (mcg/min)'"
        ),
        "data/nitro.csv"
    )

    nitro <- read_csv("data/nitro.csv")



    dobutamine <- write_csv(
        query_rows(
            connection = eicu_conn,
            table = "infusiondrug",
            columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
            rows = "drugname = 'Dobutamine (mcg/kg/min)'"
        ), "data/dobutamine.csv"
    )

    dobutamine <- read_csv("data/dobutamine.csv")

    write_csv(query_rows(
        connection = eicu_conn,
        table = "infusiondrug",
        columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
        rows = "drugname = 'Phenylephrine (mcg/hr)'"
    ), "data/phenylephrine.csv")

    phenylephrine <- read_csv("data/phenylephrine.csv")


    norepinephrine <- write_csv(
        query_rows(
            connection = eicu_conn,
            table = "infusiondrug",
            columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
            rows = "drugname = 'Norepinephrine (mcg/min)'"
        ), "data/norepinephrine.csv"
    )

    norepinephrine <- read_csv("data/norepinephrine.csv")


    write_csv(query_rows(
        connection = eicu_conn,
        table = "infusiondrug",
        columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
        rows = "drugname = 'Fentanyl (mcg/hr)'"
    ), "data/fentanyl.csv")

    fentanyl <- read_csv("data/fentanyl.csv")


    write_csv(query_rows(
        connection = eicu_conn,
        table = "infusiondrug",
        columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
        rows = "drugname = 'Midazolam (mg/hr)'"
    ), "data/midazolam.csv")
    midaz <- read_csv("data/midazolam.csv")

    write_csv(query_rows(
        connection = eicu_conn,
        table = "infusiondrug",
        columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
        rows = "drugname = 'Dexmedetomidine (mcg/kg/hr)'"
    ), "data/dexmedetomidine.csv")
    dex <- read_csv("data/dexmedetomidine.csv")


    write_csv(query_rows(
        connection = eicu_conn,
        table = "infusiondrug",
        columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
        rows = "drugname = 'Nicardipine (mg/hr)'"
    ), "data/nicardipine.csv")
    nicardipine <- read_csv("data/nicardipine.csv")


    write_csv(query_rows(
        connection = eicu_conn,
        table = "infusiondrug",
        columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
        rows = "drugname = 'Amiodarone (mg/min)'"
    ), "data/amiodarone.csv")
    amiodarone <- read_csv("data/amiodarone.csv")

    write_csv(query_rows(
        connection = eicu_conn,
        table = "infusiondrug",
        columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
        rows = "drugname = 'NSS (ml/hr)' OR
      drugname = 'IVF (ml/hr)' OR
      drugname = 'NS (ml/hr)' OR
      drugname = '0.9 Sodium Chloride (ml/hr)' OR
      drugname = 'Normal saline (ml/hr)' OR
      drugname = 'normal saline (ml/hr)' OR
      drugname = 'NACL (ml/hr)'"
    ), "data/ns.csv")

    fluids <- read_csv("data/ns.csv")


    write_csv(query_rows(
        connection = eicu_conn,
        table = "infusiondrug",
        columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
        rows = "drugname = 'Milrinone (mcg/kg/min)'"
    ), "data/milrinone.csv")
    milrinone <- read_csv("data/milrinone.csv")

    write_csv(query_rows(
        connection = eicu_conn,
        table = "infusiondrug",
        columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
        rows = "drugname = 'Epinephrine (mcg/min)'"
    ), "data/epinephrine.csv")
    epinephrine <- read_csv("data/epinephrine.csv")

    write_csv(query_rows(
        connection = eicu_conn,
        table = "infusiondrug",
        columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
        rows = "drugname = 'Vasopressin (units/min)'"
    ), "data/vasopressin.csv")
    vasopressin <- read_csv("data/vasopressin.csv")

    write_csv(query_rows(
        connection = eicu_conn,
        table = "infusiondrug",
        columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
        rows = "drugname = 'Diltiazem (mg/hr)'"
    ), "data/diltiazem.csv")
    diltiazem <- read_csv("data/diltiazem.csv")
    write_csv(query_rows(eicu_conn,
        table = "nursecharting",
        columns = "patientunitstayid,
               nursingchartoffset,
               nursingchartcelltypevalname,
               nursingchartvalue",
        rows = "nursingchartcelltypevalname = 'Non-Invasive BP Systolic'
          OR nursingchartcelltypevalname = 'Invasive BP Systolic'"
    ), "data/sbp_nurse_charting.csv")
    sbp_nurse_charting <- read_csv("data/sbp_nurse_charting.csv")
    write_csv(query_rows(eicu_conn,
        table = "nursecharting",
        columns = "patientunitstayid,
               nursingchartoffset,
               nursingchartcelltypevalname,
               nursingchartvalue",
        rows = "nursingchartcelltypevalname = 'Pain Score'"
    ), "data/pain.csv")
    pain <- read_csv("data/pain.csv")
    write_csv(query_cols(
        connection = eicu_conn,
        table = "vitalaperiodic",
        columns = "patientunitstayid,
            observationoffset,
            noninvasivesystolic"
    ), "data/vitalaperiodic.csv")
    vital_aperiodic <- read_csv("data/vitalaperiodic.csv")

    write_csv(query_cols(
        connection = eicu_conn,
        table = "vitalperiodic",
        columns = "patientunitstayid,
            observationoffset,
            systemicsystolic"
    ), "data/vital_periodic.csv")
    vital_periodic <- read_csv("data/vital_periodic.csv")
    write_csv(query_cols(
        connection = eicu_conn,
        table = "apacheapsvar",
        columns = "*"
    ), "data/apacheapsvar.csv")
    apacheapsvar <- read_csv("data/apacheapsvar.csv")
    write_csv(query_cols(
        connection = eicu_conn,
        table = "apachepatientresult",
        columns = "patientunitstayid,
       apachescore,
       apacheversion"
    ), "data/apachepatientresult.csv")
    apachepatientresult <- read_csv("data/apachepatientresult.csv")
    write_csv(query_cols(
        connection = eicu_conn,
        table = "apachepredvar",
        columns = "*"
    ), "data/apachepredvar.csv")
    apachepredvar <- read_csv("data/apachepredvar.csv")
    write_csv(query_rows(
        connection = eicu_conn,
        table = "lab",
        columns = "patientunitstayid,
      labname,
      labresultoffset,
      labresult",
        rows = "labname = 'creatinine'"
    ), "data/creatinine.csv")
    creat <- read_csv("data/creatinine.csv")
    write_csv(query_rows(
        connection = eicu_conn,
        table = "infusiondrug",
        columns = "patientunitstayid,
       infusionoffset,
       drugname,
       drugrate",
        rows = "drugname = 'Propofol (mcg/kg/min)'"
    ), "data/propofol.csv")
    propofol <- read_csv("data/propofol.csv")

    write_csv(
        join_tables(
            patient = patient,
            nitro = nitro,
            sbp_nurse_charting = sbp_nurse_charting,
            vital_aperiodic = vital_aperiodic,
            vital_periodic = vital_periodic,
            apachepatientresult = apachepatientresult,
            apachepredvar = apachepredvar,
            creat = creat,
            fentanyl = fentanyl,
            midaz = midaz,
            propofol = propofol,
            dobutamine = dobutamine,
            dex = dex,
            nicardipine = nicardipine,
            amiodarone = amiodarone,
            fluids = fluids,
            milrinone = milrinone,
            epinephrine = epinephrine,
            vasopressin = vasopressin,
            diltiazem = diltiazem,
            # this pain variable codes NAs as zero pain scores
            pain = pain
        ), "data/joinedTables.csv"
    )
    joinedTables <- read_csv("data/joinedTables.csv")

    write_csv(
        make_data_format(joinedTables),
        "data/dataFormattedRaw.csv"
    )
    dataFormattedRaw <- read_csv("data/dataFormattedRaw.csv")
    write_csv(
        dataFormattedRaw |>
            mutate(
                nitro_diff_mcg = nitro_post - nitro_pre
            ), "data/data_formatted.csv"
    )
    data_formatted <- read_csv("data/data_formatted.csv")
    time_before <- 60
    time_after <- 30
    write_csv(data_formatted |>
        filter(
            time_pre %in% 0:time_before,
            time_post %in% 5:time_after
        ) |>
        group_by(id) |>
        # only the first bp within the 5-15 min timeframe after dose titration
        distinct(n_nitro, .keep_all = T) |>
        ungroup() |>
        mutate(sbp_diff = sbp_post - sbp_pre, no_diff = 0) |>
        na.omit(), "data/dataModel.csv")
}
