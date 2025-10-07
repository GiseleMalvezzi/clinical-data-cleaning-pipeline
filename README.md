# Clinical Data Cleaning Pipeline

[![R](https://img.shields.io/badge/R-4.0+-blue.svg)](https://www.r-project.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 📋 Overview

This project provides an automated pipeline for cleaning, validating, and processing clinical research data using R. It implements best practices for data quality assurance in clinical studies, ensuring data integrity and regulatory compliance.

**Pipeline automatizado para limpeza e validação de dados clínicos em R**  
*Automated pipeline for clinical data cleaning and validation in R*

## 🎯 Objectives

- **Automate data cleaning processes** to reduce manual errors and increase efficiency
- **Ensure data quality** through comprehensive validation checks
- **Standardize clinical data** according to industry standards (e.g., CDISC)
- **Generate audit trails** for regulatory compliance
- **Produce reproducible results** through documented workflows
- **Detect and flag anomalies** in clinical datasets

## ✨ Key Features

### Data Validation
- Range checks for numerical variables
- Format validation for dates, IDs, and categorical variables
- Missing data detection and reporting
- Duplicate record identification
- Cross-field validation rules

### Data Cleaning
- Automated outlier detection and handling
- Standardization of variable names and labels
- Data type conversion and formatting
- Handling of missing values (imputation strategies)
- Text data normalization

### Quality Control
- Comprehensive data quality reports
- Visual summaries and statistical descriptions
- Inconsistency detection across related fields
- Protocol deviation identification

### Documentation
- Detailed logs of all cleaning operations
- Audit trail for regulatory compliance
- Data lineage tracking
- Automated report generation

## 📁 Folder Structure

```
clinical-data-cleaning-pipeline/
│
├── data/
│   ├── raw/              # Original, unprocessed clinical data
│   ├── interim/          # Intermediate processed data
│   └── processed/        # Final cleaned datasets
│
├── scripts/
│   ├── 01_import_data.R        # Data import and initial setup
│   ├── 02_validate_data.R      # Validation rules and checks
│   ├── 03_clean_data.R         # Data cleaning procedures
│   ├── 04_quality_checks.R     # Quality control checks
│   └── 05_export_data.R        # Export cleaned data
│
├── functions/
│   ├── validation_rules.R      # Custom validation functions
│   ├── cleaning_functions.R    # Data cleaning utilities
│   └── reporting_functions.R   # Report generation functions
│
├── config/
│   ├── config.yaml             # Configuration parameters
│   └── validation_rules.yaml   # Validation rule definitions
│
├── reports/
│   ├── data_quality/           # Data quality reports
│   ├── audit_trails/           # Audit trail logs
│   └── summary_statistics/     # Statistical summaries
│
├── tests/
│   └── test_functions.R        # Unit tests for functions
│
├── docs/
│   ├── user_guide.md           # User documentation
│   └── technical_specs.md      # Technical specifications
│
├── .gitignore
├── README.md
└── main_pipeline.R             # Main pipeline orchestration script
```

## 🚀 How to Use

### Prerequisites

Ensure you have R (version 4.0 or higher) installed along with the following packages:

```r
install.packages(c(
  "tidyverse",      # Data manipulation and visualization
  "data.table",     # Fast data processing
  "validate",       # Data validation rules
  "janitor",        # Data cleaning utilities
  "lubridate",      # Date/time handling
  "readxl",         # Excel file import
  "writexl",        # Excel file export
  "yaml",           # Configuration file handling
  "rmarkdown",      # Report generation
  "knitr",          # Document generation
  "assertr",        # Data validation
  "skimr"           # Data summaries
))
```

### Installation

1. Clone this repository:
```bash
git clone https://github.com/GiseleMalvezzi/clinical-data-cleaning-pipeline.git
cd clinical-data-cleaning-pipeline
```

2. Configure the pipeline by editing `config/config.yaml` with your project-specific parameters

3. Define custom validation rules in `config/validation_rules.yaml`

### Running the Pipeline

#### Option 1: Run the complete pipeline
```r
source("main_pipeline.R")
```

#### Option 2: Run individual steps
```r
# Step 1: Import raw data
source("scripts/01_import_data.R")

# Step 2: Validate data
source("scripts/02_validate_data.R")

# Step 3: Clean data
source("scripts/03_clean_data.R")

# Step 4: Quality checks
source("scripts/04_quality_checks.R")

# Step 5: Export cleaned data
source("scripts/05_export_data.R")
```

### Input Data Format

Place your raw clinical data files in the `data/raw/` directory. The pipeline supports:
- CSV files (`.csv`)
- Excel files (`.xlsx`, `.xls`)
- SAS files (`.sas7bdat`)
- R data files (`.RData`, `.rds`)

### Output

The pipeline generates:
1. **Cleaned datasets** in `data/processed/`
2. **Data quality reports** in `reports/data_quality/`
3. **Audit trail logs** in `reports/audit_trails/`
4. **Statistical summaries** in `reports/summary_statistics/`

## 🛠️ Technologies Used

### Core Technologies
- **R (4.0+)**: Primary programming language
- **RStudio**: Recommended IDE for development

### Key R Packages

| Package | Purpose |
|---------|----------|
| `tidyverse` | Data manipulation (dplyr, tidyr), visualization (ggplot2) |
| `data.table` | High-performance data processing |
| `validate` | Implementing data validation rules |
| `janitor` | Data cleaning and table utilities |
| `lubridate` | Date and time manipulation |
| `assertr` | Data pipeline verification |
| `skimr` | Quick data summaries |
| `rmarkdown` | Dynamic report generation |
| `yaml` | Configuration file management |

### Standards & Best Practices
- **CDISC standards** compatibility (optional)
- **ALCOA+ principles** (Attributable, Legible, Contemporaneous, Original, Accurate, Complete, Consistent, Enduring, Available)
- **GCP compliance** (Good Clinical Practice)
- **21 CFR Part 11** considerations for electronic records

## 📊 Validation Rules

The pipeline implements multiple validation layers:

1. **Structural validation**: Data types, required fields, format compliance
2. **Range validation**: Numerical and date ranges, reference values
3. **Logical validation**: Cross-field consistency, protocol compliance
4. **Statistical validation**: Outlier detection, distribution checks

## 📈 Quality Metrics

The pipeline tracks and reports:
- Completeness rate (% of non-missing values)
- Accuracy metrics (based on validation rules)
- Consistency scores (cross-field validation)
- Data entry error rates
- Protocol deviation rates

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**Gisele Malvezzi**
- GitHub: [@GiseleMalvezzi](https://github.com/GiseleMalvezzi)

## 📞 Contact

For questions, suggestions, or issues, please open an issue on GitHub.

## 🙏 Acknowledgments

- Clinical research community for best practices
- R community for excellent data science tools
- Open-source contributors

---

**Note**: This pipeline is designed for research purposes. For production clinical trial data, ensure compliance with all applicable regulatory requirements and consult with your data management team and regulatory affairs department.
