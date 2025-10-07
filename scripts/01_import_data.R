# ==============================================================================
# Script: 01_import_data.R
# Projeto: Clinical Data Cleaning Pipeline
# Descrição: Importação e diagnóstico inicial de dados oncológicos
# Autor: Gisele Malvezzi
# Data: 2025-10-07
# ==============================================================================

# Carregando bibliotecas necessárias
library(tidyverse)    # Manipulação de dados
library(readr)        # Importação de arquivos CSV
library(skimr)        # Overview detalhado dos dados
library(janitor)      # Limpeza de nomes de variáveis
library(lubridate)    # Manipulação de datas

# ==============================================================================
# 1. CONFIGURAÇÃO DE DIRETÓRIOS
# ==============================================================================

cat("\n========================================\n")
cat("INICIANDO IMPORTAÇÃO DE DADOS\n")
cat("========================================\n\n")

# Definindo diretórios
dir_raw <- "data/raw/"
dir_interim <- "data/interim/"

# Verificando se os diretórios existem, caso contrário, cria
if (!dir.exists(dir_interim)) {
  dir.create(dir_interim, recursive = TRUE)
  cat("✓ Diretório 'data/interim/' criado\n")
}

# ==============================================================================
# 2. IMPORTAÇÃO DOS DADOS
# ==============================================================================

cat("\n[1] Importando dados oncológicos...\n")

# Verificando se o arquivo existe
arquivo_cancer <- paste0(dir_raw, "Cancer_Data.csv")

if (!file.exists(arquivo_cancer)) {
  stop("ERRO: Arquivo 'Cancer_Data.csv' não encontrado em ", dir_raw)
}

# Importando dados
tryCatch({
  cancer_data <- read_csv(
    arquivo_cancer,
    col_types = cols(),
    locale = locale(encoding = "UTF-8")
  )
  cat("✓ Dados importados com sucesso!\n")
}, error = function(e) {
  stop("ERRO ao importar dados: ", e$message)
})

# ==============================================================================
# 3. DIAGNÓSTICO INICIAL DOS DADOS
# ==============================================================================

cat("\n[2] Realizando diagnóstico inicial...\n\n")

# 3.1 Dimensões do dataset
cat("--- DIMENSÕES DO DATASET ---\n")
cat("Número de observações (linhas):", nrow(cancer_data), "\n")
cat("Número de variáveis (colunas):", ncol(cancer_data), "\n\n")

# 3.2 Estrutura dos dados
cat("--- ESTRUTURA DOS DADOS ---\n")
glimpse(cancer_data)
cat("\n")

# 3.3 Nomes das variáveis
cat("--- NOMES DAS VARIÁVEIS ---\n")
cat(paste(names(cancer_data), collapse = ", "), "\n\n")

# 3.4 Primeiras observações
cat("--- PRIMEIRAS 10 OBSERVAÇÕES ---\n")
print(head(cancer_data, 10))
cat("\n")

# 3.5 Overview completo com skimr
cat("--- OVERVIEW DETALHADO (SKIMR) ---\n")
print(skim(cancer_data))
cat("\n")

# 3.6 Verificação de valores ausentes
cat("--- ANÁLISE DE VALORES AUSENTES ---\n")
missing_summary <- cancer_data %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "Variável", values_to = "N_Missing") %>%
  mutate(
    Pct_Missing = round(N_Missing / nrow(cancer_data) * 100, 2)
  ) %>%
  arrange(desc(N_Missing))

print(missing_summary)
cat("\n")

# 3.7 Verificação de duplicatas
cat("--- VERIFICAÇÃO DE DUPLICATAS ---\n")
n_duplicates <- cancer_data %>%
  duplicated() %>%
  sum()
cat("Número de linhas duplicadas:", n_duplicates, "\n\n")

# 3.8 Sumário estatístico básico
cat("--- SUMÁRIO ESTATÍSTICO ---\n")
print(summary(cancer_data))
cat("\n")

# ==============================================================================
# 4. SALVANDO DATASET INICIAL
# ==============================================================================

cat("[3] Salvando dataset inicial...\n")

# Salvando em data/interim
arquivo_saida <- paste0(dir_interim, "cancer_data_inicial.csv")

tryCatch({
  write_csv(cancer_data, arquivo_saida)
  cat("✓ Dataset salvo em:", arquivo_saida, "\n")
}, error = function(e) {
  stop("ERRO ao salvar arquivo: ", e$message)
})

# ==============================================================================
# 5. REGISTRO DE INFORMAÇÕES DO PROCESSO
# ==============================================================================

cat("\n[4] Gerando log de importação...\n")

# Criando registro do processo
log_importacao <- list(
  data_hora = Sys.time(),
  arquivo_origem = arquivo_cancer,
  arquivo_destino = arquivo_saida,
  n_observacoes = nrow(cancer_data),
  n_variaveis = ncol(cancer_data),
  variaveis = names(cancer_data),
  n_duplicatas = n_duplicates,
  valores_ausentes = missing_summary
)

# Salvando log
arquivo_log <- paste0("reports/audit_trails/log_importacao_", 
                      format(Sys.time(), "%Y%m%d_%H%M%S"), ".rds")

if (!dir.exists("reports/audit_trails/")) {
  dir.create("reports/audit_trails/", recursive = TRUE)
}

saveRDS(log_importacao, arquivo_log)
cat("✓ Log salvo em:", arquivo_log, "\n")

# ==============================================================================
# 6. FINALIZAÇÃO
# ==============================================================================

cat("\n========================================\n")
cat("IMPORTAÇÃO CONCLUÍDA COM SUCESSO!\n")
cat("========================================\n")
cat("\nPróximo passo: Execute o script 02_validate_data.R\n\n")

# Mensagem final
message("✓ Script 01_import_data.R executado com sucesso!")
message("  Dataset disponível no objeto: cancer_data")
message("  Arquivo salvo: ", arquivo_saida)
