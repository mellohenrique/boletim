# Carregando pacotes
## Esta parte do script funciona para carregar todos os pacotes necessarios para criação do boletim
library(magrittr)
library(httr)
library(readr)
library(devtools)

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

gera_boletim_ra(arquivo = "dados/2021-01-04-cadastro.csv")

# Remova os arquivos baixados posteriormente para não pesar no servidor. 
