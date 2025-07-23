#!/bin/bash
# run-de-test.sh

module load R/4.2.0

# Submit Jobs
Rscript scripts/submit-differential-analysis-jobs-multiome.R
