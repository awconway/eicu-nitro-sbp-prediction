library(tidymodels)
library(tidyverse)
library(bigrquery)
library(glue)

library(doParallel)
no_cores <- detectCores()
cl <- makeCluster(no_cores - 2)
registerDoParallel(cl)

sourceDir <- function(path, trace = TRUE, ...) {
    for (nm in list.files(path, pattern = "\\.[RrSsQq]$")) {
        if (trace) cat(nm, ":")
        source(file.path(path, nm), ...)
        if (trace) cat("\n")
    }
}

sourceDir("R")

set.seed(5292)

if (!dir.exists("data")) {
  dir.create("data")
}
if (!dir.exists("figures")) {
  dir.create("figures")
}


####### only need to run this section once #######

# Connecting to the eicu bigquery database

eicu_conn  <- Sys.getenv("BIGQUERY_ACCOUNT")

get_data()

#################################################

dataModel <- read_csv("data/dataModel.csv")

# use rmse for metrics
mset <- metric_set(rmse)

control <-
    control_grid(
        save_workflow = TRUE,
        save_pred = TRUE,
        extract = extract_model
    )
controlResamples <-
    control_resamples(
        save_workflow = TRUE,
        save_pred = TRUE,
        extract = extract_model
    )
multiples <-
    dataModel |>
    group_by(id) |>
    count() |>
    arrange(desc(n)) |>
    filter(n > 1) |>
    pull(id)
trainingResponse <-
    dataModel |>
    filter(id %in% multiples) |>
    add_lag_nitro()

foldsIndexResponse <- make_kfold(trainingResponse, 5)
init_split <-
    custom_rsplit(
        foldsIndexResponse,
        which(foldsIndexResponse$fold != 1),
        which(foldsIndexResponse$fold == 1)
    )

training <- training(init_split)
testing <- testing(init_split)
foldsFiveResponse <-
    group_vfold_cv(make_kfold(training |> select(-fold), 5),
        group = fold,
        v = 5
    )
baselineTesting <- testing |>
    metrics(
        truth = sbp_post,
        estimate = sbp_pre
    )

# Linear Regression model
recipeRegression <-
    recipe(
        sbp_post ~
            sbp_pre +
            nitro_diff_mcg +
            total_nitro +
            n_nitro +
            nitro_time +
            time_pre +
            time_post +
            sbp_pre_mean_60 +
            sbp_pre_mean_120 +
            lag_sbp_pre +
            lag_mean_sbp_pre +
            lag_sbp_post +
            lag_mean_sbp_post,
        data = training
    ) |>
    step_normalize(
        all_numeric_predictors()
    )

specLR <-
    linear_reg(
        mode = "regression",
    ) |>
    set_engine("lm")

workflowLRResponse <-
    workflow() |>
    add_recipe(recipeRegression) |>
    add_model(specLR)
tuningLRResponse <-
    fit_resamples(
        workflowLRResponse,
        resamples = foldsFiveResponse
    )
# lasso model
specLasso <-
    linear_reg(
        penalty = tune(),
        mixture = 1
    ) |>
    set_engine("glmnet")
gridLasso <-
    dials::grid_regular(dials::penalty(),
        levels = 100
    )
workflowLassoResponse <-
    workflow() |>
    add_recipe(recipeRegression) |>
    add_model(specLasso)
tuningLassoResponse <-
    tune_grid(
        workflowLassoResponse,
        resamples = foldsFiveResponse,
        grid = gridLasso
    )

# Ridge Model
## Specifications for the ridge model
specRidgeResponse <-
    linear_reg(
        penalty = tune(),
        mixture = 0 # Changed from 1 to 0
    ) |>
    set_engine("glmnet")
## Grid search to determine the best value for the penalty parameter (i.e. amount of regularization)
gridRidge <-
    dials::grid_regular(dials::penalty(),
        levels = 100
    )
## Run the model using 5-fold cross-validation
workflowRidgeResponse <-
    workflow() |>
    add_recipe(recipeRegression) |>
    add_model(specRidgeResponse)
tuningRidgeResponse <-
    tune_grid(
        workflowRidgeResponse,
        resamples = foldsFiveResponse,
        grid = gridRidge
    )
autoGluonPredictors <- c(
    "fold",
    "sbp_post",
    "sbp_pre",
    "nitro_diff_mcg",
    "total_nitro",
    "n_nitro",
    "nitro_time",
    "time_pre",
    "time_post",
    "sbp_pre_mean_60",
    "sbp_pre_mean_120",
    "lag_sbp_pre",
    "lag_mean_sbp_pre",
    "lag_sbp_post",
    "lag_mean_sbp_post"
)

# linear models
finalLRfit <- last_fit(workflowLRResponse, init_split)
finalLRmetrics <- collect_metrics(finalLRfit)
finalLassoFit <- last_fit(
    finalize_workflow(workflowLassoResponse, select_best(tuningLassoResponse)),
    init_split
)
finalLassoMetrics <- collect_metrics(finalLassoFit)
finalRidgeFit <- last_fit(
    finalize_workflow(workflowRidgeResponse, select_best(tuningRidgeResponse)),
    init_split
)
finalRidgeMetrics <- collect_metrics(finalRidgeFit)
summary_table <- make_summary_table(foldsIndexResponse)

joinedTables <- read_csv("data/joinedTables.csv")
data_formatted <- read_csv("data/data_formatted.csv")
nitro <- read_csv("data/nitro.csv")

flow_diagram <- make_flow_diagram(
    dataModel,
    foldsIndexResponse,
    joinedTables,
    nitro,
    data_formatted
)
titrations_plot <- make_titrations_plot(foldsIndexResponse)
hospitals_plot <- make_hospitals_plot(foldsIndexResponse)

# make csvs for autogluon

training |>
      select(all_of(autoGluonPredictors)) |>
      write_csv("data/autoGluon_training.csv")
testing |>
      select(all_of(autoGluonPredictors)) |>
      write_csv("data/autoGluon_testing.csv")


# make csvs for the top 5 hospitals for training

highest_hospitals <-  foldsIndexResponse |>
    group_by(hospitalid) |>
    count(sort = TRUE) |>
    head(5) |> pull(hospitalid)

walk(1:5, function(x) {
      foldsIndexResponse |>
        filter(hospitalid != highest_hospitals[x]) |>
        select(all_of(autoGluonPredictors)) |>
        write_csv(glue::glue("data/autoGluon_{x}.csv"))
    })
# make csvs for the top 5 hospitals for testing
walk(1:5, function(x) {
      foldsIndexResponse |>
        filter(hospitalid == highest_hospitals[x]) |>
        select(all_of(autoGluonPredictors)) |>
        write_csv(glue::glue("data/autoGluon_{x}_testing.csv"))
    })


# run the autogluon model in python

# system2("python","python-scripts/autogluon.py")

# read in the autogluon results

autogluonLeaderboard <-
    read_csv("data/agLeaderboard_training.csv")

autogluonFeatureImportance <-
      read_csv("data/agFeatureImportance.csv")
feature_importance_plot  <-
    make_feature_importance_plot(autogluonFeatureImportance)


hospitalCVperformance <- {
    map_dfr(1:5, function(x) {
        leaderboard <- read_csv(glue::glue("data/agLeaderboard_{x}.csv"))
        score <- leaderboard |>
            filter(model == "WeightedEnsemble_L2") |>
            pull(score_test)

        foldsIndexResponse |>
            filter(hospitalid == highest_hospitals[x]) |>
            metrics(
                truth = sbp_post,
                estimate = sbp_pre,
            ) |>
            filter(.metric == "rmse") |>
            mutate(
                prediction = score * -1,
                diff = 1 - prediction / .estimate
            )
    }) |>
        mutate(
            hospitalid = 1:5
        ) |>
        rename(
            `Persistence Model` = .estimate,
            `Ensemble Model` = prediction
        )
}

hospitalCVperformancePlot <-
    make_hospitalCVperformancePlot(hospitalCVperformance)
