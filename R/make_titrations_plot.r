make_titrations_plot <- function(foldsIndexResponse) {
    titrations <- foldsIndexResponse |>
        group_by(id) |>
        count() |>
        arrange(desc(n)) |>
        ggplot(aes(x = n)) +
        geom_histogram(bins = 200) +
        # remove background
        theme_minimal() +
        labs(x = "Number of nitroglycerin titrations", y = "Number of patients")

    titrations
    # save as a png
    # ggsave("figures/nitro_titrations.png", plot = titrations, device = "png", dpi = 300)
}
