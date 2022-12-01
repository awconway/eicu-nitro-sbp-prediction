make_results_summary = function(autogluonLeaderboard) {
    table = autogluonLeaderboard |>
    select(model, score_test) |>
    rename("Root mean square error on test set" = score_test,
    "Model" = model)|>
    gt::gt()

    # gt::gtsave(table, "autogluon_table.docx")
}