make_autogluonFeatureImportance = function(testing){
    autogluon = reticulate::import("autogluon.tabular")
    predictor = autogluon$TabularPredictor$load('agModels_training')
    imp = predictor$feature_importance(testing, model='WeightedEnsemble_L2')
}