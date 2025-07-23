# submit-differential-analysis-jobs-multiome.R
library(glue)
library(dplyr)
library(Seurat)
library(Signac)
library(yaml)

source("scripts/functions/main-functions.R")
source("scripts/functions/utils.R")

## 0. Load Configs
config <- read_yaml("config.yml")

seu_obj_path <- config$input$seu_obj_path
group.by <- config$analysis$group_by
condition <- config$analysis$condition_column
ident.1 <- config$analysis$ident_1
ident.2 <- config$analysis$ident_2

## 1. Load Seurat Object
seu_obj <- readRDS(seu_obj_path)

if (is.list(seu_obj)) {
  seu_obj <- seu_obj[[1]]
}

## 2. Get Unique Factors in Column to Subset by (ie. celltype)
unique_group_by_factors <- unique(seu_obj@meta.data[[group.by]])

## 3. Create Output Directories
create.dir("jobs")
create.dir("logs")
create.dir("diff-test-outputs")

## 4. Submit Separate Jobs For All Column Factors
lapply(unique_group_by_factors, function(sub_group) {
  submit_job_scripts(
    seu_obj_path = seu_obj_path,
    group.by = group.by,
    condition = condition,
    ident.1 = ident.1,
    ident.2 = ident.2,
    sub_group = sub_group
  )
})
