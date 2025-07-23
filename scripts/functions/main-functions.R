# main-functions.R

# 1. Submit Job Scripts
submit_job_scripts <- function(seu_obj_path, group.by, condition, ident.1, ident.2, sub_group) {

    # Create a job script for each sub_group
    job_script <- glue::glue("
        #!/bin/bash
        #BSUB -q premium
        #BSUB -P acc_naiklab
        #BSUB -J job_{sub_group}
        #BSUB -o logs/job_{sub_group}.out
        #BSUB -e logs/job_{sub_group}.err
        #BSUB -n 5
        #BSUB -R 'rusage[mem=10000]'
        #BSUB -W 01:00

        Rscript scripts/run-all-differential-analysis-multiome.R {seu_obj_path} {group.by} {condition} {sub_group} {ident.1} {ident.2}"
    )

    # Save the script
    script_path <- paste0("jobs/job_", sub_group, ".sh")
    writeLines(as.character(job_script), script_path)

    # Submit it
    system(glue::glue("bsub < {script_path}"))
}

# 2. Run Differential Tests
log_reg_da_function <- function(seu_obj, group.by, condition, sub_group, ident.1, ident.2) {
  
  # Subset Sub Group
  seu_obj <- JoinLayers(seu_obj, assay = "RNA")
  seu_obj <- NormalizeData(seu_obj, assay = "RNA")
  seu_obj_sub <- subset(seu_obj, subset = !!as.name(group.by) == sub_group)

  # DE Genes
  DefaultAssay(seu_obj_sub) <- "RNA"
  
  Idents(seu_obj_sub) <- condition
  rna_markers <- Seurat::FindMarkers(seu_obj_sub, ident.1 = ident.1, ident.2 = ident.2)
  
  rna_markers <- rna_markers %>%
    rename_with(.fn = ~ as.character(glue("pct.{ident.1}")), .cols = "pct.1") %>%
    rename_with(.fn = ~ as.character(glue("pct.{ident.2}")), .cols = "pct.2")
  
  # DA Peaks 
  DefaultAssay(seu_obj_sub) <- "peaks"

  seu_obj_sub <- Signac::RunTFIDF(seu_obj_sub)
  peak_markers <- FindMarkers(
    object = seu_obj_sub,
    ident.1 = ident.1,
    ident.2 = ident.2,
    test.use = 'LR',
    latent.vars = 'nCount_peaks',
    min.pct = 0.1
  )

  peak_markers$p_adj_value_BH <- p.adjust(peak_markers$p_val, method = "BH")
  
  peak_markers <-  peak_markers %>%
    rename_with(.fn = ~ as.character(glue("pct.{ident.1}")), .cols = "pct.1") %>%
    rename_with(.fn = ~ as.character(glue("pct.{ident.2}")), .cols = "pct.2")
  
  return(list("DE_results" = rna_markers, "DA_results" = peak_markers))
}
