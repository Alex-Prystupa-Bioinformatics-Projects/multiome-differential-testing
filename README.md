
# MULTIOME-DIFFERENTIAL-TESTING
## Overview
**Multiome-Differential-Testing**

Quick way to run differentional gene expression & differential peak accessibility on Seurat multiome objects for all your celltypes. 
Specify meta data celltype column, Condition to test and idents to compare.
Automatically submits separate jobs per celltype on HPC to run analysis quicker.
Runs Log-Reg differential accessibility testing on DA analysis.

## Project Structure

```sh
└── multiome-differential-testing/
    ├── config.yml
    ├── run-differential-tests.sh
    └── scripts
        ├── functions
        ├── run-all-differential-analysis-multiome.R
        └── submit-differential-analysis-jobs-multiome.R
```

## Usage
1. git clone https://github.com/Alex-Prystupa-Bioinformatics-Projects/multiome-differential-testing.git
2. Edit config.yml file with necessary parameters (examples shown in default config.yml)
3. ./run-differential-tests.sh
