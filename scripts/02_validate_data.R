# ==============================================================================
# Script: 02_validate_data.R
# Description: Initial validation of clinical data
# - Missing values check
# - Duplicate identification
# - Age range validation (if Age column exists)
# - Sex variable category validation
# - Export missing values report by variable
# ==============================================================================

# Loading packages -------------------------------------------------------------
library(dplyr)
library(janitor)

# Data import ------------------------------------------------------------------
# Assuming data was imported in the previous script
# If necessary, adjust the file path
if (!exists("cancer_data")) {
  message("Data not found. Loading...")
  # Example: cancer_data <- readr::read_csv("data/raw/raw_data.csv")
}

# 1. MISSING VALUES CHECK ------------------------------------------------------
message("\n=== MISSING VALUES ANALYSIS ===")

# Count of missing values by variable
missing_by_variable <- cancer_data %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  tidyr::pivot_longer(cols = everything(),
                      names_to = "variable",
                      values_to = "n_missing") %>%
  mutate(pct_missing = round((n_missing / nrow(cancer_data)) * 100, 2)) %>%
  arrange(desc(n_missing))

print(missing_by_variable)

# 2. DUPLICATE IDENTIFICATION --------------------------------------------------
message("\n=== DUPLICATE ANALYSIS ===")

# Check for complete duplicates
complete_duplicates <- cancer_data %>%
  janitor::get_dupes()

if (nrow(complete_duplicates) > 0) {
  message(paste("WARNING:", nrow(complete_duplicates), "duplicate rows found!"))
  print(complete_duplicates)
} else {
  message("No complete duplicates found.")
}

# 3. AGE RANGE VALIDATION ------------------------------------------------------
if ("Age" %in% names(cancer_data)) {
  message("\n=== AGE VALIDATION ===")
  
  age_stats <- cancer_data %>%
    summarise(
      min_age = min(Age, na.rm = TRUE),
      max_age = max(Age, na.rm = TRUE),
      mean_age = mean(Age, na.rm = TRUE),
      median_age = median(Age, na.rm = TRUE),
      n_negative = sum(Age < 0, na.rm = TRUE),
      n_above_120 = sum(Age > 120, na.rm = TRUE)
    )
  
  print(age_stats)
  
  # Alert for suspicious values
  if (age_stats$n_negative > 0) {
    warning(paste("WARNING:", age_stats$n_negative, "negative age values found!"))
  }
  
  if (age_stats$n_above_120 > 0) {
    warning(paste("WARNING:", age_stats$n_above_120, "age values above 120 years found!"))
  }
} else {
  message("\n=== 'Age' variable not found in dataset ===")
}

# 4. SEX VARIABLE CATEGORY VALIDATION ------------------------------------------
if ("Sex" %in% names(cancer_data)) {
  message("\n=== SEX VALIDATION ===")
  
  sex_freq <- cancer_data %>%
    count(Sex, name = "frequency") %>%
    mutate(percentage = round((frequency / sum(frequency)) * 100, 2)) %>%
    arrange(desc(frequency))
  
  print(sex_freq)
  
  # Expected categories (adjust as needed)
  expected_categories <- c("M", "F", "Male", "Female")
  unexpected_categories <- sex_freq %>%
    filter(!Sex %in% expected_categories & !is.na(Sex))
  
  if (nrow(unexpected_categories) > 0) {
    warning("WARNING: Unexpected categories in 'Sex' found:")
    print(unexpected_categories)
  }
} else {
  message("\n=== 'Sex' variable not found in dataset ===")
}

# 5. MISSING VALUES REPORT EXPORT ----------------------------------------------
message("\n=== EXPORTING MISSING VALUES REPORT ===")

# Create directory if it doesn't exist
if (!dir.exists("reports/data_quality")) {
  dir.create("reports/data_quality", recursive = TRUE)
  message("Directory 'reports/data_quality' created.")
}

# Export report
readr::write_csv(missing_by_variable, 
                 "reports/data_quality/missing_by_variable.csv")
message("Report exported: reports/data_quality/missing_by_variable.csv")

# FINAL SUMMARY ----------------------------------------------------------------
message("\n=== VALIDATION SUMMARY ===")
message(paste("Total observations:", nrow(cancer_data)))
message(paste("Total variables:", ncol(cancer_data)))
message(paste("Duplicates found:", nrow(complete_duplicates)))
message(paste("Variables with missing values:", sum(missing_by_variable$n_missing > 0)))
message("\nValidation completed!")
