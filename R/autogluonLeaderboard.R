make_autogluonLeaderboard = function(testing){
    autogluon = reticulate::import("autogluon.tabular")
    predictor = autogluon$TabularPredictor$load('agModels_training')
    predictor$leaderboard(testing, extra_metrics=list('r2'))
}