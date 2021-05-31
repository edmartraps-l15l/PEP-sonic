################################################################################
## Descripción: Lectura y exploración de datos
## Autor: Edmar Trápaga Vieyra
## Fecha: 24 de mayo de 2021
################################################################################

pacman::p_load(tidyverse,
               haven,
               janitor)

################################################################################
## 0. Preliminares -------------------------------------------------------------
################################################################################

base_implicita <- 
  read_sav('data/Data Visualizador Pepsi Irlanda/Raw SPSS files/Final Implicit data 10-5-21.sav')

base_ola_1 <- 
  read_sav('data/Data Visualizador Pepsi Irlanda/Raw SPSS files/Wave 1 data 10-5-21.sav')

basebase_ola_2 <- 
  read_sav('data/Data Visualizador Pepsi Irlanda/Raw SPSS files/Wave 2 data 10-5-21.sav')

################################################################################
## 1. Exploratorio de datos ----------------------------------------------------
################################################################################

# 1.1. Base implicita -----------------------------------------------------

base_ola_1 %>% 
  select(-contains('HIDDEN'), -contains('BANNER'), -contains('Driver')) %>% 
  names() %>% 
  enframe() %>% 
  View()

base_implicita %>% 
  select(contains('banner')) %>% 
  as_factor() %>% 
  View

base_implicita %>% 
  names() %>% 
  enframe() %>% 
  View()

base_ola_1 %>% 
  select('SERIAL')

base_ola_2 %>% 
  select(contains('resp'), everything())

base_implicita %>% 
  select(respid)

################################################################################
##  ----------------------------------------------------
################################################################################

