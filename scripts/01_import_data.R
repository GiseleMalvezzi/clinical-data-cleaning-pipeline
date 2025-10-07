# ==============================================================================
# Script: 01_import_data.R
# Project: Clinical Data Cleaning Pipeline
# Description: Import and initial diagnosis of oncological data
# Author: Gisele Malvezzi
# Date: 2025-10-07
# ==============================================================================

# Loading required libraries
library(tidyverse)    # Data manipulation
library(readr)        # CSV file import
library(skimr)        # Detailed data overview
library(janitor)      # Variable name cleaning
library(lubridate)    # Date manipulation

# ==============================================================================
# 1. DIRECTORY CONFIGURATION
# ==============================================================================

cat("\n========================================\n")
cat("STARTING DATA IMPORT\n")
cat("========================================\n\n")

# Defining directories
dir_raw <- "data/raw/"
dir_interim <- "data/interim/"

# Checking if directories exist, otherwise create them
if (!dir.exists(dir_interim)) {
  dir.create(dir_interim, recursive = TRUE)
  cat("✓ Directory 'data/interim/' created\n")
}

# ==============================================================================
# 2. DATA IMPORT
# ==============================================================================

cat("\n[1] Importing oncological data...\n")

# Checking if file exists
file_cancer <- paste0(dir_raw, "Cancer_Data.csv")

if (!file.exists(file_cancer)) {
  stop("ERROR: File 'Cancer_Data.csv' not found in ", dir_raw)
}

# Importing data
tryCatch({
  cancer_data <- read_csv(
    file_cancer,
    col_types = cols(),
    locale = locale(encoding = "UTF-8")
  )
  cat("✓ Data imported successfully!\n")
}, error = function(e) {
  stop("ERROR importing data: ", e$message)
})

# ==============================================================================
# 3. INITIAL DATA DIAGNOSIS
# ==============================================================================

cat("\n[2] Performing initial diagnosis...\n\n")

# 3.1 Dataset dimensions
cat("--- DATASET DIMENSIONS ---\n")
cat("Number of observations (rows):", nrow(cancer_data), "\n")
cat("Number of variables (columns):", ncol(cancer_data), "\n\n")

# 3.2 Data structure
cat("--- DATA STRUCTURE ---\n")
glimpse(cancer_data)
cat("\n")

# 3.3 Variable names
cat("--- VARIABLE NAMES ---\n")
cat(paste(names(cancer_data), collapse = ", "), "\n\n")

# 3.4 First observations
cat("--- FIRST 10 OBSERVATIONS ---\n")
print(head(cancer_data, 10))
cat("\n")

# 3.5 Complete overview with skimr
cat("--- DETAILED OVERVIEW (SKIMR) ---\n")
print(skim(cancer_data))
cat("\n")

# 3.6 Missing values check
cat("--- MISSING VALUES ANALYSIS ---\n")
missing_summary <- cancer_data %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "Variable", values_to = "N_Missing") %>%
  mutate(
    Pct_Missing = round(N_Missing / nrow(cancer_data) * 100, 2)
  ) %>%
  arrange(desc(N_Missing))

print(missing_summary)
cat("\n")

# 3.7 Duplicate check
cat("--- DUPLICATE CHECK ---\n")
n_duplicates <- cancer_data %>%
  duplicated() %>%
  sum()

cat("Number of duplicate rows:", n_duplicates, "\n\n")

# 3.8 Basic statistical summary
cat("--- STATISTICAL SUMMARY ---\n")
print(summary(cancer_data))
cat("\n")

# ==============================================================================
# 4. SAVING INITIAL DATASET
# ==============================================================================

cat("[3] Saving initial dataset...\n")

# Saving to data/interim
output_file <- paste0(dir_interim, "cancer_data_initial.csv")

tryCatch({
  write_csv(cancer_data, output_file)
  cat("✓ Dataset saved at:", output_file, "\n")
}, error = function(e) {
  stop("ERROR saving file: ", e$message)
})

# ==============================================================================
# 5. PROCESS INFORMATION LOG
# ==============================================================================

cat("\n[4] Generating import log...\n")

# Creating process log
import_log <- list(
  datetime = Sys.time(),
  source_file = file_cancer,
  destination_file = output_file,
  n_observations = nrow(cancer_data),
  n_variables = ncol(cancer_data),
  variables = names(cancer_data),
  n_duplicates = n_duplicates,
  missing_values = missing_summary
)

# Saving log
log_file <- paste0("reports/audit_trails/import_log_", 
                   format(Sys.time(), "%Y%m%d_%H%M%S"), ".rds")

if (!dir.exists("reports/audit_trails/")) {
  dir.create("reports/audit_trails/", recursive = TRUE)
}

saveRDS(import_log, log_file)
cat("✓ Log saved at:", log_file, "\n")

# ==============================================================================
# 6. COMPLETION
# ==============================================================================

cat("\n========================================\n")
cat("IMPORT COMPLETED SUCCESSFULLY!\n")
cat("========================================\n")
cat("\nNext step: Run script 02_validate_data.R\n\n")

# Final message
message("✓ Script 01_import_data.R executed successfully!")
message("  Dataset available in object: cancer_data")
message("  File saved: ", output_file)
