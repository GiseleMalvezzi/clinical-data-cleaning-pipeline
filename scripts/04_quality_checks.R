# ============================================================================
# Script: 04_quality_checks.R
# Objetivo: Realizar verificações de qualidade nos dados limpos
# Autor: Gisele Malvezzi
# Data: 2025-10-07
# ============================================================================

# Carregar pacotes necessários
library(tidyverse)
library(skimr)

# Definir diretórios
data_dir <- "processed"

# ============================================================================
# 1. LEITURA DOS DADOS LIMPOS
# ============================================================================

cat("\n=== INICIANDO CONTROLE DE QUALIDADE DOS DADOS ===\n\n")

# Ler arquivo de dados limpos
cat("Lendo dados limpos...\n")
cancer_data_clean <- read_csv(
  file.path(data_dir, "cancer_data_clean.csv"),
  show_col_types = FALSE
)

cat("Dados carregados com sucesso!\n")
cat("Dimensões:", nrow(cancer_data_clean), "linhas x", 
    ncol(cancer_data_clean), "colunas\n\n")

# ============================================================================
# 2. ANÁLISE SUMÁRIA COM SKIMR
# ============================================================================

cat("=== OVERVIEW DOS DADOS LIMPOS ===\n\n")

# Gerar overview completo
data_summary <- skim(cancer_data_clean)
print(data_summary)

cat("\n")

# ============================================================================
# 3. VERIFICAÇÕES ADICIONAIS DE QUALIDADE
# ============================================================================

cat("=== VERIFICAÇÕES DE QUALIDADE ===\n\n")

# Verificar valores ausentes por coluna
cat("Valores ausentes por coluna:\n")
missing_summary <- cancer_data_clean %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "Coluna", values_to = "NA_count") %>%
  filter(NA_count > 0) %>%
  arrange(desc(NA_count))

if(nrow(missing_summary) > 0) {
  print(missing_summary, n = Inf)
} else {
  cat("Nenhum valor ausente encontrado!\n")
}

cat("\n")

# Verificar duplicatas
cat("Verificando duplicatas...\n")
duplicates <- cancer_data_clean %>%
  group_by(across(everything())) %>%
  filter(n() > 1) %>%
  ungroup()

if(nrow(duplicates) > 0) {
  cat("ATENÇÃO:", nrow(duplicates), "linhas duplicadas encontradas!\n")
} else {
  cat("Nenhuma linha duplicada encontrada.\n")
}

cat("\n")

# ============================================================================
# 4. MENSAGEM DE CONFIRMAÇÃO
# ============================================================================

cat("\n=== CONTROLE DE QUALIDADE CONCLUÍDO COM SUCESSO ===\n\n")
cat("Resumo final:\n")
cat("  - Total de registros:", nrow(cancer_data_clean), "\n")
cat("  - Total de variáveis:", ncol(cancer_data_clean), "\n")
cat("  - Completude geral:", 
    round(100 * (1 - sum(is.na(cancer_data_clean)) / 
                   (nrow(cancer_data_clean) * ncol(cancer_data_clean))), 2), "%\n")
cat("\nOs dados estão prontos para análise!\n")
cat("\n============================================================================\n")
