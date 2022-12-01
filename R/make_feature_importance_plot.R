make_feature_importance_plot <- function(autogluonFeatureImportance) {
    plot = autogluonFeatureImportance |>
        rename(feature = `...1`)|>
        mutate(Level = ifelse(importance > 0, "high", "low")) %>%
        # change names of feature to more readable names
        mutate(feature = case_when(
            feature == "sbp_pre" ~ "Blood pressure prior to titration",
            feature == "sbp_pre_mean_120" ~ "Mean blood pressure over 2 hours prior to titration",
            feature == "sbp_pre_mean_60" ~ "Mean blood pressure over 1 hour prior to titration",
            feature == "lag_mean_sbp_post" ~ "Mean of all previous post-titration blood pressures",
            feature == "lag_mean_sbp_pre" ~ "Mean of all previous pre-titration blood pressures",
            feature == "lag_mad_sbp_pre" ~ "Median absolute deviation of all previous pre-titration blood pressures",
            feature == "lag_mad_sbp_post" ~ "Median absolute deviation of all previous post-titration blood pressures",
            feature == "lag_sbp_post" ~ "Immediately previous post-titration blood pressure",
            feature == "lag_sbp_pre" ~ "Immediately previous pre-titration blood pressure",
            feature == "n_nitro" ~ "Total dose titrations of nitroglycerin",
            feature == "nitro_time" ~ "Total time on nitroglycerin",
            feature == "total_nitro" ~ "Total dose of nitroglycerin received",
            feature == "time_pre" ~ "Time since blood pressure measurement prior to titration",
            feature == "time_post" ~ "Time to blood pressure measurement post-titration",
            feature == "nitro_diff_mcg" ~ "Nitroglycerin dose titration in mcg",
            feature == "lag_mad_nitro_diff" ~ "Median absolute deviation of all prior nitroglycerin dose titrations",
            feature == "lag_mean_nitro_diff" ~ "Mean of all prior nitroglycerin dose titrations",
            feature == "lag_nitro_diff" ~ "Prior nitroglycerin dose titration",
            TRUE ~ as.character(feature)
        ))|>
        ggplot(aes(reorder(feature, importance), importance)) +
        geom_bar(stat = "identity", position = "identity") +
        coord_flip() +
        theme_minimal() +
        # remove legend
        theme(legend.position = "none") +
        # remove y-axis label
        theme(axis.title.y = element_blank()) +
        # change x axis label
        labs(x = "Feature", y = "Importance")
        # save as a png
    # ggsave("figures/feature_importance.png", plot = plot, device = "png", dpi = 300)

}
