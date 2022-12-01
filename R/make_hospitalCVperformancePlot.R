make_hospitalCVperformancePlot = function(hospitalCVperformance) {
    plot = 
    hospitalCVperformance |>
      ggplot() +
      geom_segment(
        data = hospitalCVperformance,
        aes(
          x = hospitalid,
          y = 15.3,
          yend = `Ensemble Model`,
          xend = hospitalid,
        ),
        color = "#aeb6bf",
        size = 2, # Note that I sized the segment to fit the points
        alpha = .5
      ) +
      geom_point(aes(
        y = `Ensemble Model`, 
        x = hospitalid, 
      ), size = 4, show.legend = TRUE) +
      # dashed horizontal line at 15.3
      geom_hline(yintercept = 15.3, linetype="dashed", color = "#aeb6bf", size = 1.5) +
      # start y axis at 0
      scale_y_continuous(limits = c(0, 18)) +
        theme_minimal()+
        labs(x="Hospital", y="Root mean square error")
        # save plot
        # ggsave("figures/hospitalCVperformance.png", plot, width = 10, height = 6, units = "in", dpi = 300)
}