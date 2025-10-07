# ==============================================================================
# Script: 04_quality_checks.R
# Project: Clinical Data Cleaning Pipeline
# Description: Perform quality checks on clean clinical data
# Author: Gisele Malvezzi
# Date: 2025-10-07
# ==============================================================================

# Load necessary packages
library(tidyverse)
library(skimr)

# Define directories
data_dir <- "data/processed"

# ==============================================================================
# 1. LOAD CLEAN DATA
# ==============================================================================
cat("\n=== STARTING DATA QUALITY CONTROL ===\n\n")

# Read clean data file
cat("Loading clean data...\n")
cancer_data_clean <- read_csv(
  file.path(data_dir, "cancer_data_clean.csv"),
  show_col_types = FALSE
)

cat("Data loaded successfully!\n")
cat("Dimensions:", nrow(cancer_data_clean), "rows x", 
    ncol(cancer_data_clean), "columns\n\n")

# ==============================================================================
# 2. SUMMARY ANALYSIS WITH SKIMR
# ==============================================================================
cat("=== CLEAN DATA OVERVIEW ===\n\n")

# Generate complete overview
data_summary <- skim(cancer_data_clean)
print(data_summary)
cat("\n")

# ==============================================================================
# 3. ADDITIONAL QUALITY CHECKS
# ==============================================================================
cat("=== QUALITY CHECKS ===\n\n")

# Check missing values by column
cat("Missing values by column:\n")
missing_summary <- cancer_data_clean %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "Column", values_to = "NA_count") %>%
  filter(NA_count > 0) %>%
  arrange(desc(NA_count))

if(nrow(missing_summary) > 0) {
  print(missing_summary, n = Inf)
} else {
  cat("No missing values found!\n")
}
cat("\n")

# Check for duplicates
cat("Checking for duplicates...\n")
duplicates <- cancer_data_clean %>%
  group_by(across(everything())) %>%
  filter(n() > 1) %>%
  ungroup()

if(nrow(duplicates) > 0) {
  cat("WARNING:", nrow(duplicates), "duplicate rows found!\n")
} else {
  cat("No duplicate rows found.\n")
}
cat("\n")

# ==============================================================================
# 4. COMPLETION MESSAGE
# ==============================================================================
cat("\n=== QUALITY CONTROL COMPLETED SUCCESSFULLY ===\n\n")

cat("Final summary:\n")
cat("  - Total records:", nrow(cancer_data_clean), "\n")
cat("  - Total variables:", ncol(cancer_data_clean), "\n")
cat("  - Overall completeness:", 
    round(100 * (1 - sum(is.na(cancer_data_clean)) / 
                   (nrow(cancer_data_clean) * ncol(cancer_data_clean))), 2), "%\n")

cat("\nData is ready for analysis!\n")
cat("\n==============================================================================\n")
