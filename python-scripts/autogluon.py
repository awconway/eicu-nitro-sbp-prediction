from autogluon.tabular import TabularPredictor, TabularDataset

def make_autogluon_model(file_name):
    training = TabularDataset(f'data/autoGluon_{file_name}.csv')
    save_path = f'agModels_{file_name}'
    TabularPredictor(label="sbp_post", path=save_path, groups = "fold", problem_type="regression").fit(training,
    presets='best_quality')

make_autogluon_model("training")

def make_autogluon_eval(training, testing):
    testing = TabularDataset(f'data/autoGluon_{testing}.csv')
    save_path = f'agModels_{training}'
    predictor = TabularPredictor.load(save_path)
    predictor.leaderboard(testing).to_csv(f'data/agLeaderboard_{training}.csv')

make_autogluon_eval(training = "training", testing = "testing")

def make_autogluon_featureImportance(model, testing):
    testing = TabularDataset(f'data/autoGluon_{testing}.csv')
    save_path = f'agModels_{model}'
    predictor = TabularPredictor.load(save_path)
    predictor.feature_importance(testing, model='WeightedEnsemble_L2', num_shuffle_sets=10).to_csv('data/agFeatureImportance.csv')

make_autogluon_featureImportance(model = "training", testing = "testing")

# internal-external validation
for i in range(1,6):
    make_autogluon_model(i)

for i in range(1,6):
    make_autogluon_eval(i, f'{i}_testing')