################################################################################
## Descripción: Creación de las bases para Sonic
## Autor: Edmar Trápaga Vieyra
## Fecha: 26 de mayo de 2021
################################################################################

pacman::p_load(tidyverse,
               haven,
               janitor,
               rLQL)

################################################################################
## 0. Preliminares -------------------------------------------------------------
################################################################################

base_ola_1 <- 
  read_sav('data/Data Visualizador Pepsi Irlanda/Raw SPSS files/Wave 1 data 10-5-21.sav') %>% 
  clean_names() %>% 
  select(b_yyuno:b_amyws,country_2:tsc_6)

base_ola_1 %<>% 
  rename(committed = b_yyuno,
         weary = b_fghjf,
         concerned = b_ggino,
         unwilling = b_auezt,
         pragmatic = b_gingv,
         conformist = b_amyws) %>% 
  as_factor

base_ola_2 <- 
  read_sav('data/Data Visualizador Pepsi Irlanda/Raw SPSS files/Wave 2 data 10-5-21.sav')

################################################################################
## 1. Creación de bases de ola 1 -----------------------------------------------
################################################################################

write_rds(base_ola_1, 'cache/ola_1.rds')
