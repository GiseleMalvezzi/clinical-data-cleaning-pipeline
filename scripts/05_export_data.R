# ==============================================================================
# Script 05: Exportação de Dados Limpos para Excel
# Descrição: Exporta os dados oncológicos limpos para formato Excel (.xlsx)
#            utilizando o pacote writexl
# Autor: Pipeline de Limpeza de Dados Clínicos
# Data: 2025-10-07
# ==============================================================================

# Carregar pacotes necessários
library(writexl)

# Definir caminhos de arquivos
input_file <- "processed/cancer_data_clean.csv"
output_file <- "processed/cancer_data_clean.xlsx"

# Ler dados limpos do CSV
cat("Lendo dados limpos de", input_file, "...\n")
cancer_data_clean <- read.csv(input_file)

# Exibir informações sobre os dados
cat("\nInformações dos dados a serem exportados:\n")
cat("Número de linhas:", nrow(cancer_data_clean), "\n")
cat("Número de colunas:", ncol(cancer_data_clean), "\n")
cat("Colunas:", paste(names(cancer_data_clean), collapse = ", "), "\n\n")

# Exportar para Excel
cat("Exportando dados para", output_file, "...\n")
write_xlsx(cancer_data_clean, output_file)

# Verificar se o arquivo foi criado com sucesso
if (file.exists(output_file)) {
  file_size <- file.size(output_file)
  cat("\n✓ SUCESSO: Dados exportados com sucesso!\n")
  cat("  Arquivo:", output_file, "\n")
  cat("  Tamanho:", round(file_size / 1024, 2), "KB\n")
  cat("\nOs dados limpos estão prontos para análise no Excel.\n")
} else {
  cat("\n✗ ERRO: Falha ao criar o arquivo Excel.\n")
}

cat("\n=== Exportação concluída ===")
