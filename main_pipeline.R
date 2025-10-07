# ============================================================================
# CLINICAL DATA CLEANING PIPELINE - Main Orchestration Script
# ============================================================================
# Project: Clinical Data Cleaning Pipeline
# Author: Gisele Malvezzi
# Description: Main pipeline orchestration script that coordinates all data
#              cleaning, validation, and quality control processes
# ============================================================================

# Clear environment
rm(list = ls())

# Set working directory (adjust as needed)
# setwd("path/to/clinical-data-cleaning-pipeline")

# Load required packages
library(tidyverse)   # Data manipulation and visualization
library(data.table)  # Fast data processing
library(validate)    # Data validation
library(janitor)     # Data cleaning utilities
library(lubridate)   # Date/time handling
library(yaml)        # Configuration file handling

cat("\n============================================================================\n")
cat("CLINICAL DATA CLEANING PIPELINE\n")
cat("============================================================================\n\n")

# ============================================================================
# STEP 0: LOAD CONFIGURATION AND CUSTOM FUNCTIONS
# ============================================================================
cat("[STEP 0] Loading configuration and custom functions...\n")

# Load configuration file
config <- read_yaml("config/config.yaml")

# Source custom functions
source("functions/validation_rules.R")
source("functions/cleaning_functions.R")
source("functions/reporting_functions.R")

cat("[STEP 0] Configuration and functions loaded successfully\n\n")

# ============================================================================
# STEP 1: IMPORT RAW DATA
# ============================================================================
cat("[STEP 1] Importing raw clinical data...\n")

# Execute data import script
source("scripts/01_import_data.R")

cat("[STEP 1] Data import completed successfully\n")
cat("         Records imported:", nrow(raw_data), "\n\n")

# ============================================================================
# STEP 2: DATA VALIDATION
# ============================================================================
cat("[STEP 2] Running data validation checks...\n")

# Execute validation script
source("scripts/02_validate_data.R")

cat("[STEP 2] Data validation completed\n")
cat("         Validation issues identified:", validation_summary$total_issues, "\n\n")

# ============================================================================
# STEP 3: DATA CLEANING
# ============================================================================
cat("[STEP 3] Performing data cleaning procedures...\n")

# Execute cleaning script
source("scripts/03_clean_data.R")

cat("[STEP 3] Data cleaning completed successfully\n")
cat("         Records cleaned:", nrow(cleaned_data), "\n\n")

# ============================================================================
# STEP 4: QUALITY CONTROL CHECKS
# ============================================================================
cat("[STEP 4] Running quality control checks...\n")

# Execute quality control script
source("scripts/04_quality_checks.R")

cat("[STEP 4] Quality control checks completed\n")
cat("         Data quality score:", round(quality_metrics$overall_score, 2), "%\n\n")

# ============================================================================
# STEP 5: EXPORT CLEANED DATA
# ============================================================================
cat("[STEP 5] Exporting cleaned data and reports...\n")

# Execute export script
source("scripts/05_export_data.R")

cat("[STEP 5] Data export completed successfully\n")
cat("         Output location: data/processed/\n\n")

# ============================================================================
# PIPELINE COMPLETION
# ============================================================================
cat("============================================================================\n")
cat("PIPELINE EXECUTION COMPLETED SUCCESSFULLY\n")
cat("============================================================================\n")
cat("\n")
cat("Summary:\n")
cat("  - Raw records:", nrow(raw_data), "\n")
cat("  - Cleaned records:", nrow(cleaned_data), "\n")
cat("  - Validation issues:", validation_summary$total_issues, "\n")
cat("  - Data quality score:", round(quality_metrics$overall_score, 2), "%\n")
cat("  - Execution time:", format(Sys.time() - pipeline_start_time), "\n")
cat("\n")
cat("Reports generated:\n")
cat("  - Data quality report: reports/data_quality/\n")
cat("  - Audit trail: reports/audit_trails/\n")
cat("  - Summary statistics: reports/summary_statistics/\n")
cat("\n")
cat("============================================================================\n\n")

# Clean up temporary variables (optional)
# rm(pipeline_start_time)
