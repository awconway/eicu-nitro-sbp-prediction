# Predicting blood pressure changes after nitroglcerin dose titration using the eicu dataset

This repository holds the source code to conduct an analysis using data from the [eicu](https://eicu-crd.mit.edu) database. The goal is to predict the systolic blood pressure after a nitroglycerin dose titration.

## Reproducible analysis with Docker

The statistical analyses requires various packages to be installed, and may not work properly if package versions have changed. You can use github's codespaces or the remote development extension in vscode on a computer with docker installed to open this repo and reproduce the analyses, but you would need your own access to the eicu database (details below).

### Connecting to the eicu bigquery database

First, follow the instructions to gain access through [physionet](https://eicu-crd.mit.edu). Once you have access to the data on bigquery, run the following code in the RStudio session and follow instructions in a pop-up browser to copy your token to the console:

```r
Sys.setenv(BIGQUERY_ACCOUNT="the billing account you want to use to query the eicu data")
bigrquery::bq_auth(email = "your gmail address associated with physionet account")
```

>Make sure to select the option to allow access to bigquery


## Running the workflow

`workflow.R` has the code required to reproduce the analyses.

    