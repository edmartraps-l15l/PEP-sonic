################################################################################
## Descripción: Catálogos para el estudio de Sonic  
## Autor: Edmar Trápaga Vieyra
## Fecha: 27 de mayo de 2021
################################################################################

pacman::p_load(readxl)

cat_q2 <- 
  read_xlsx('data/Data Visualizador Pepsi Irlanda/Sonic 2.0 data tables 14-2-21 Quant 1.xlsx',
            sheet = 'Q2.1. All bev by BANNER',
            range = 'A4:A30') %>% 
  mutate(letra = letters[1:26]) %>% 
  set_names(c('Phrase', 'letra')) 


