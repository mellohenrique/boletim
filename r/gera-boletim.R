# Carregando pacotes
## Esta parte do script funciona para carregar todos os pacotes necessarios para criação do boletim

### Pacotes de terceiros
use_package <- function(p) {
  if (!is.element(p, installed.packages()[,1])){
    install.packages(p, dep = TRUE)}
  require(p, character.only = TRUE)
}

use_package("readr")
use_package("readxl")
use_package("devtools")

### Pacote do boletim
if (!is.element("codeplan.boletim", installed.packages()[,1])){
  devtools::install_github("mellohenrique/codeplan.boletim")
}
library("codeplan.boletim")

# Obtendo dados
link <- GET("https://xx9p7hp1p7.execute-api.us-east-1.amazonaws.com/prod/PortalGeral",
            add_headers("X-Parse-Application-Id" = 
                          "unAFkcaNDeXajurGB7LChj8SgQYS2ptm")) %>%
  content() %>%
  '[['("results") %>%
  '[['(1) %>%
  '[['("arquivo") %>%
  '[['("url")

# Salvando os dados baixados do ministério da saúde no servidor
write_excel_csv2(data.table::fread(link, sep = ";", dec = ","), "dados/min_saude.csv")

# Gerando boletim
gera_boletim(arquivo = "dados/min_saude.csv")

gera_boletim_ra(arquivo = "dados/2020-12-28-cadastro.csv")

# Remova os arquivos baixados posteriormente para não pesar no servidor. 
