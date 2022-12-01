make_hospitals_plot <- function(foldsIndexResponse) {

hospital_patients = foldsIndexResponse|>
distinct(patientunitstayid, .keep_all = T)|>
group_by(hospitalid) |>
      count() |>
      arrange(desc(n)) |>
      ggplot(aes(x = reorder(hospitalid, n), y = n)) +
        geom_col() +
        # remove background
        theme_minimal() +
        # remove x-axis labels
        theme(axis.text.x = element_blank()) +
        # change x-axis label
        labs(x = "Hospital", y = "Number of patients")
        # save as a png
# ggsave("figures/hospital_patients.png", plot = hospital_patients, device = "png", dpi = 300)
}