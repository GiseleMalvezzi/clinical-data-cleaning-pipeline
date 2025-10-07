# ==============================================================================
# Script: 05_export_data.R
# Project: Clinical Data Cleaning Pipeline
# Description: Export clean clinical data to Excel format
# Author: Gisele Malvezzi
# Date: 2025-10-07
# ==============================================================================

# Load necessary packages
library(writexl)

# Define file paths
input_file <- "processed/cancer_data_clean.csv"
output_file <- "processed/cancer_data_clean.xlsx"

# Read clean data from CSV
cat("Reading clean data from", input_file, "...\n")
cancer_data_clean <- read.csv(input_file)

# Display information about the data
cat("\nInformation about data to be exported:\n")
cat("Number of rows:", nrow(cancer_data_clean), "\n")
cat("Number of columns:", ncol(cancer_data_clean), "\n")
cat("Columns:", paste(names(cancer_data_clean), collapse = ", "), "\n\n")

# Export to Excel
cat("Exporting data to", output_file, "...\n")
write_xlsx(cancer_data_clean, output_file)

# Verify if file was created successfully
if (file.exists(output_file)) {
  file_size <- file.size(output_file)
  cat("\n✓ SUCCESS: Data exported successfully!\n")
  cat("  File:", output_file, "\n")
  cat("  Size:", round(file_size / 1024, 2), "KB\n")
  cat("\nClean data is ready for analysis in Excel.\n")
} else {
  cat("\n✗ ERROR: Failed to create Excel file.\n")
}

cat("\n=== Export completed ===")
