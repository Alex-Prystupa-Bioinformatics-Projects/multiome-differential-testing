#!/bin/bash
# run-de-test.sh

module load R/4.2.0

# Global Vars
seu_path="/sc/arion/projects/naiklab/Alex/Jack-Multiome/scmultiome-pipeline/output/RDS-files/jm-multiome-grouped-peaks-Annotation_Condition-callpeaks-obj-list-updated-names.RDS"
group_by="Annotation_V1"
condition="Condition"
ident_1="IMQ"
ident_2="CTRL"

# Submit Jobs
Rscript scripts/submit-differential-analysis-jobs-multiome.R
