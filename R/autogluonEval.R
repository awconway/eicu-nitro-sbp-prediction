make_autogluonEval <- function(testing, file_name) {
    autogluon <- reticulate::import("autogluon.tabular")
    predictor <- autogluon$TabularPredictor$load(glue::glue("agModels_{file_name}"))
    # predictor$evaluate(testing)
    leaderboard <- predictor$leaderboard(testing)
    leaderboard |>
        filter(model == "WeightedEnsemble_L2") |>
        pull(score_test)
}
