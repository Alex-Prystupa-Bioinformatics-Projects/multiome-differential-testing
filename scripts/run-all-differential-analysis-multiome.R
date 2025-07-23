# differential-testing-function.R
library(glue)
library(dplyr)
library(Seurat)
library(Signac)

source("scripts/functions/main-functions.R")

args <- commandArgs(trailingOnly = TRUE)

## 0. Load Job Args
seu_obj_path <- args[1]
group.by <- args[2]
condition <- args[3]
sub_group <- args[4]
ident.1 <- args[5]
ident.2 <- args[6]

# For Logs
print(glue("Loading Seurat object from: {seu_obj_path}"))
print(glue("Grouping cells by: {group.by}"))
print(glue("Condition column: {condition}"))
print(glue("Sub-group of interest: {sub_group}"))
print(glue("Comparing ident.1 = '{ident.1}' vs ident.2 = '{ident.2}'"))

## 1. Load Seurat Object
seu_obj <- readRDS(args[1])

if (is.list(seu_obj)) {
  seu_obj <- seu_obj[[1]]
}

## 2. Run Differential Testing
results <- log_reg_da_function(seu_obj, group.by, condition, sub_group, ident.1, ident.2)

## 3. Save Results
results$DE_results %>% write.csv(glue("diff-test-outputs/DE-Gene-Results-{sub_group}-{ident.1}-vs-{ident.2}.csv"), quote = FALSE)
results$DA_results %>% write.csv(glue("diff-test-outputs/DA-Peak-Results-{sub_group}-{ident.1}-vs-{ident.2}.csv"), quote = FALSE)
