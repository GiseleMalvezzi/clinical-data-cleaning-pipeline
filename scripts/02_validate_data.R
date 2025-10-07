# ==============================================================================
# Script: 02_validate_data.R
# Descrição: Validação inicial dos dados clínicos
# - Checagem de valores missing
# - Identificação de duplicatas
# - Validação de range de idade (se existir coluna Age)
# - Validação de categorias da variável Sex
# - Exportação de relatório de missing por variável
# ==============================================================================

# Carregamento de pacotes ------------------------------------------------------
library(dplyr)
library(janitor)

# Importação dos dados ---------------------------------------------------------
# Assumindo que os dados foram importados no script anterior
# Se necessário, ajuste o caminho do arquivo
if (!exists("dados")) {
  message("Dados não encontrados. Carregando...")
  # Exemplo: dados <- readr::read_csv("data/raw/dados_brutos.csv")
}

# 1. CHECAGEM DE VALORES MISSING -----------------------------------------------
message("\n=== ANÁLISE DE VALORES MISSING ===")

# Contagem de missing por variável
missing_por_variavel <- dados %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  tidyr::pivot_longer(cols = everything(),
                      names_to = "variavel",
                      values_to = "n_missing") %>%
  mutate(perc_missing = round((n_missing / nrow(dados)) * 100, 2)) %>%
  arrange(desc(n_missing))

print(missing_por_variavel)

# 2. IDENTIFICAÇÃO DE DUPLICATAS -----------------------------------------------
message("\n=== ANÁLISE DE DUPLICATAS ===")

# Verifica duplicatas completas
duplicatas_completas <- dados %>%
  janitor::get_dupes()

if (nrow(duplicatas_completas) > 0) {
  message(paste("ATENÇÃO:", nrow(duplicatas_completas), "linhas duplicadas encontradas!"))
  print(duplicatas_completas)
} else {
  message("Nenhuma duplicata completa encontrada.")
}

# 3. VALIDAÇÃO DE RANGE DE IDADE -----------------------------------------------
if ("Age" %in% names(dados)) {
  message("\n=== VALIDAÇÃO DE IDADE ===")
  
  idade_stats <- dados %>%
    summarise(
      min_idade = min(Age, na.rm = TRUE),
      max_idade = max(Age, na.rm = TRUE),
      media_idade = mean(Age, na.rm = TRUE),
      mediana_idade = median(Age, na.rm = TRUE),
      n_negativos = sum(Age < 0, na.rm = TRUE),
      n_acima_120 = sum(Age > 120, na.rm = TRUE)
    )
  
  print(idade_stats)
  
  # Alerta para valores suspeitos
  if (idade_stats$n_negativos > 0) {
    warning(paste("ATENÇÃO:", idade_stats$n_negativos, "valores de idade negativos encontrados!"))
  }
  
  if (idade_stats$n_acima_120 > 0) {
    warning(paste("ATENÇÃO:", idade_stats$n_acima_120, "valores de idade acima de 120 anos encontrados!"))
  }
} else {
  message("\n=== Variável 'Age' não encontrada no dataset ===")
}

# 4. VALIDAÇÃO DE CATEGORIAS DA VARIÁVEL SEX -----------------------------------
if ("Sex" %in% names(dados)) {
  message("\n=== VALIDAÇÃO DE SEXO ===")
  
  sex_freq <- dados %>%
    count(Sex, name = "frequencia") %>%
    mutate(percentual = round((frequencia / sum(frequencia)) * 100, 2)) %>%
    arrange(desc(frequencia))
  
  print(sex_freq)
  
  # Categorias esperadas (ajuste conforme necessário)
  categorias_esperadas <- c("M", "F", "Male", "Female", "Masculino", "Feminino")
  categorias_inesperadas <- sex_freq %>%
    filter(!Sex %in% categorias_esperadas & !is.na(Sex))
  
  if (nrow(categorias_inesperadas) > 0) {
    warning("ATENÇÃO: Categorias inesperadas em 'Sex' encontradas:")
    print(categorias_inesperadas)
  }
} else {
  message("\n=== Variável 'Sex' não encontrada no dataset ===")
}

# 5. EXPORTAÇÃO DO RELATÓRIO DE MISSING ----------------------------------------
message("\n=== EXPORTANDO RELATÓRIO DE MISSING ===")

# Cria diretório se não existir
if (!dir.exists("reports/data_quality")) {
  dir.create("reports/data_quality", recursive = TRUE)
  message("Diretório 'reports/data_quality' criado.")
}

# Exporta relatório
readr::write_csv(missing_por_variavel, 
                 "reports/data_quality/missing_por_variavel.csv")

message("Relatório exportado: reports/data_quality/missing_por_variavel.csv")

# SUMÁRIO FINAL ----------------------------------------------------------------
message("\n=== SUMÁRIO DA VALIDAÇÃO ===")
message(paste("Total de observações:", nrow(dados)))
message(paste("Total de variáveis:", ncol(dados)))
message(paste("Duplicatas encontradas:", nrow(duplicatas_completas)))
message(paste("Variáveis com missing:", sum(missing_por_variavel$n_missing > 0)))
message("\nValidação concluída!")
