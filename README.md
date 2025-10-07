# Clinical Data Cleaning Pipeline
![R CMD check](https://github.com/GiseleMalvezzi/clinical-data-cleaning-pipeline/actions/workflows/ci-check.yaml/badge.svg)

Pipeline automatizado em R para limpeza e validação de dados clínicos.

## ✨ Recursos
- Detecção de outliers (métodos estatísticos)
- Padronização de variável e conversão de tipos
- Tratamento de valores ausentes (imputação configurável)
- Normalização de textos e harmonização de dados
- Relatórios de qualidade com resumos visuais
- Audit trail completo (conformidade regulatória)
- Rastreamento de linhagem de dados

## 🛠️ Stack
**R**: tidyverse, data.table, validate, janitor, lubridate, readxl, writexl, yaml, rmarkdown

## 🚀 Uso
```bash
# Clonar repositório
git clone https://github.com/GiseleMalvezzi/clinical-data-cleaning-pipeline.git
cd clinical-data-cleaning-pipeline

# Instalar pacotes (R 4.0+)
install.packages(c("tidyverse", "data.table", "validate", "janitor", "lubridate", "readxl", "writexl", "yaml", "rmarkdown", "knitr", "assertr"))

# Executar pipeline
source("clean_clinical_data.R")
```

## 📝 Licença
MIT
