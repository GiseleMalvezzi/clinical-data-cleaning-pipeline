# ==============================================================================
# Script: 03_clean_data.R
# Description: Clinical data cleaning - duplicates removal,
#              NA values treatment, variable standardization
# Author: GiseleMalvezzi
# Date: 2025-10-07
# ==============================================================================

# Load necessary packages
library(dplyr)
library(readr)

# Clear environment
rm(list = ls())

cat("\n========================================\n")
cat("Starting clinical data cleaning\n")
cat("========================================\n\n")

# ==============================================================================
# 1. IMPORT DATA
# ==============================================================================

cat("[1/6] Loading validated data...\n")

# Check if file exists
if (!file.exists("data/raw/cancer_data.csv")) {
  stop("Error: File data/raw/cancer_data.csv not found!")
}

# Import data
data <- read_csv("data/raw/cancer_data.csv", show_col_types = FALSE)

cat("    ✓ Data loaded successfully\n")
cat("    - Original records:", nrow(data), "\n\n")

# ==============================================================================
# 2. REMOVE DUPLICATES
# ==============================================================================

cat("[2/6] Removing duplicates...\n")

# Count duplicates before removal
duplicates <- sum(duplicated(data))

# Remove complete duplicates
data_clean <- data %>%
  distinct()

cat("    ✓ Duplicates removed:", duplicates, "\n")
cat("    - Records after removal:", nrow(data_clean), "\n\n")

# ==============================================================================
# 3. REMOVE ROWS WITH NA Patient_ID
# ==============================================================================

cat("[3/6] Removing rows with missing Patient_ID...\n")

# Count records with NA Patient_ID
na_patient_id <- sum(is.na(data_clean$Patient_ID))

# Remove rows where Patient_ID is NA
data_clean <- data_clean %>%
  filter(!is.na(Patient_ID))

cat("    ✓ Records with NA Patient_ID removed:", na_patient_id, "\n")
cat("    - Remaining records:", nrow(data_clean), "\n\n")

# ==============================================================================
# 4. FILTER AGE OUTSIDE EXPECTED RANGE
# ==============================================================================

cat("[4/6] Filtering ages outside expected range...\n")

# Define expected range (0-120 years)
min_age <- 0
max_age <- 120

# Count records outside range
invalid_ages <- sum(data_clean$Age < min_age | 
                    data_clean$Age > max_age | 
                    is.na(data_clean$Age))

# Filter valid ages
data_clean <- data_clean %>%
  filter(Age >= min_age & Age <= max_age & !is.na(Age))

cat("    ✓ Records with invalid age removed:", invalid_ages, "\n")
cat("    - Valid range: [", min_age, ",", max_age, "]\n")
cat("    - Remaining records:", nrow(data_clean), "\n\n")

# ==============================================================================
# 5. STANDARDIZE Sex VARIABLE
# ==============================================================================

cat("[5/6] Standardizing Sex variable...\n")

# Show unique values before standardization
cat("    - Unique values before:", paste(unique(data_clean$Sex), collapse = ", "), "\n")

# Standardize Sex: M -> Male, F -> Female
data_clean <- data_clean %>%
  mutate(Sex = case_when(
    Sex == "M" ~ "Male",
    Sex == "F" ~ "Female",
    TRUE ~ Sex  # Keep other values as is
  ))

cat("    ✓ Sex variable standardized\n")
cat("    - Unique values after:", paste(unique(data_clean$Sex), collapse = ", "), "\n")
cat("    - Distribution: Male =", sum(data_clean$Sex == "Male"), 
    ", Female =", sum(data_clean$Sex == "Female"), "\n\n")

# ==============================================================================
# 6. SAVE CLEAN DATA
# ==============================================================================

cat("[6/6] Saving clean data...\n")

# Create directory if it doesn't exist
if (!dir.exists("data/processed")) {
  dir.create("data/processed", recursive = TRUE)
  cat("    ✓ Directory data/processed created\n")
}

# Save clean data
write_csv(data_clean, "data/processed/cancer_data_clean.csv")

cat("    ✓ Clean data saved to: data/processed/cancer_data_clean.csv\n")
cat("    - Total clean records:", nrow(data_clean), "\n")
cat("    - Total variables:", ncol(data_clean), "\n\n")

# ==============================================================================
# FINAL SUMMARY
# ==============================================================================

cat("========================================\n")
cat("CLEANING SUMMARY\n")
cat("========================================\n")
cat("Original records:       ", nrow(data), "\n")
cat("Duplicates removed:     ", duplicates, "\n")
cat("NA Patient_ID removed:  ", na_patient_id, "\n")
cat("Invalid ages removed:   ", invalid_ages, "\n")
cat("Final records:          ", nrow(data_clean), "\n")
cat("Retention rate:         ", 
    round(100 * nrow(data_clean) / nrow(data), 2), "%\n")
cat("========================================\n")
cat("Cleaning completed successfully!\n")
cat("========================================\n\n")
