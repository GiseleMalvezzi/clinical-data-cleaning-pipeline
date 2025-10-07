# ==============================================================================
# Script: 03_clean_data.R
# Descrição: Limpeza de dados oncológicos - remoção de duplicatas,
#            tratamento de valores NA, padronização de variáveis
# Autor: GiseleMalvezzi
# Data: 2025-10-07
# ==============================================================================

# Carregar pacotes necessários
library(dplyr)
library(readr)

# Limpar ambiente
rm(list = ls())

cat("\n========================================\n")
cat("Iniciando limpeza de dados oncológicos\n")
cat("========================================\n\n")

# ==============================================================================
# 1. IMPORTAR DADOS
# ==============================================================================

cat("[1/6] Carregando dados validados...\n")

# Verificar se o arquivo existe
if (!file.exists("data/raw/cancer_data.csv")) {
  stop("Erro: Arquivo data/raw/cancer_data.csv não encontrado!")
}

# Importar dados
data <- read_csv("data/raw/cancer_data.csv", show_col_types = FALSE)

cat("    ✓ Dados carregados com sucesso\n")
cat("    - Registros originais:", nrow(data), "\n\n")

# ==============================================================================
# 2. REMOVER DUPLICATAS
# ==============================================================================

cat("[2/6] Removendo duplicatas...\n")

# Contar duplicatas antes da remoção
duplicatas <- sum(duplicated(data))

# Remover duplicatas completas
data_clean <- data %>%
  distinct()

cat("    ✓ Duplicatas removidas:", duplicatas, "\n")
cat("    - Registros após remoção:", nrow(data_clean), "\n\n")

# ==============================================================================
# 3. REMOVER LINHAS COM Patient_ID NA
# ==============================================================================

cat("[3/6] Removendo linhas com Patient_ID ausente...\n")

# Contar registros com Patient_ID NA
na_patient_id <- sum(is.na(data_clean$Patient_ID))

# Remover linhas onde Patient_ID é NA
data_clean <- data_clean %>%
  filter(!is.na(Patient_ID))

cat("    ✓ Registros com Patient_ID NA removidos:", na_patient_id, "\n")
cat("    - Registros restantes:", nrow(data_clean), "\n\n")

# ==============================================================================
# 4. FILTRAR IDADE FORA DO ESPERADO
# ==============================================================================

cat("[4/6] Filtrando idades fora do intervalo esperado...\n")

# Definir intervalo esperado (0-120 anos)
idade_min <- 0
idade_max <- 120

# Contar registros fora do intervalo
idades_invalidas <- sum(data_clean$Age < idade_min | 
                        data_clean$Age > idade_max | 
                        is.na(data_clean$Age))

# Filtrar idades válidas
data_clean <- data_clean %>%
  filter(Age >= idade_min & Age <= idade_max & !is.na(Age))

cat("    ✓ Registros com idade inválida removidos:", idades_invalidas, "\n")
cat("    - Intervalo válido: [", idade_min, ",", idade_max, "]\n")
cat("    - Registros restantes:", nrow(data_clean), "\n\n")

# ==============================================================================
# 5. PADRONIZAR VARIÁVEL Sex
# ==============================================================================

cat("[5/6] Padronizando variável Sex...\n")

# Mostrar valores únicos antes da padronização
cat("    - Valores únicos antes:", paste(unique(data_clean$Sex), collapse = ", "), "\n")

# Padronizar Sex: M -> Male, F -> Female
data_clean <- data_clean %>%
  mutate(Sex = case_when(
    Sex == "M" ~ "Male",
    Sex == "F" ~ "Female",
    TRUE ~ Sex  # Manter outros valores como estão
  ))

cat("    ✓ Variável Sex padronizada\n")
cat("    - Valores únicos depois:", paste(unique(data_clean$Sex), collapse = ", "), "\n")
cat("    - Distribuição: Male =", sum(data_clean$Sex == "Male"), 
    ", Female =", sum(data_clean$Sex == "Female"), "\n\n")

# ==============================================================================
# 6. SALVAR DADOS LIMPOS
# ==============================================================================

cat("[6/6] Salvando dados limpos...\n")

# Criar diretório se não existir
if (!dir.exists("data/processed")) {
  dir.create("data/processed", recursive = TRUE)
  cat("    ✓ Diretório data/processed criado\n")
}

# Salvar dados limpos
write_csv(data_clean, "data/processed/cancer_data_clean.csv")

cat("    ✓ Dados limpos salvos em: data/processed/cancer_data_clean.csv\n")
cat("    - Total de registros limpos:", nrow(data_clean), "\n")
cat("    - Total de variáveis:", ncol(data_clean), "\n\n")

# ==============================================================================
# RESUMO FINAL
# ==============================================================================

cat("========================================\n")
cat("RESUMO DA LIMPEZA\n")
cat("========================================\n")
cat("Registros originais:     ", nrow(data), "\n")
cat("Duplicatas removidas:    ", duplicatas, "\n")
cat("Patient_ID NA removidos: ", na_patient_id, "\n")
cat("Idades inválidas removidas:", idades_invalidas, "\n")
cat("Registros finais:        ", nrow(data_clean), "\n")
cat("Taxa de retenção:        ", 
    round(100 * nrow(data_clean) / nrow(data), 2), "%\n")
cat("========================================\n")
cat("Limpeza concluída com sucesso!\n")
cat("========================================\n\n")
