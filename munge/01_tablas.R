################################################################################
## Descripción: Tablas para la ola 1   
## Autor: Edmar Trápaga Vieyra
## Fecha: 26 de mayo de 2021
################################################################################

pacman::p_load(tidyverse,
               clipr,
               magrittr)

################################################################################
## 0. Preliminares -------------------------------------------------------------
################################################################################

source('lib/01_funciones.R')

source('lib/02_catalogos.R')

# n = 5204
ola_1 <- 
  read_rds('cache/ola_1.rds') %>% 
  mutate(folio = 1:n(),
         s1 = case_when(
           s1 >= 16 & s1 <= 24 ~ '16_24',
           s1 > 24 & s1 <= 34 ~ '25_34',
           s1 > 34 & s1 <= 54 ~ '35_54'
         ),
         c5 = case_when(
           c5 == '1' ~ 1,
           c5 == '2' ~ 2,
           c5 == '3' ~ 3,
           c5 == '4' ~ 4,
           c5 == '5 or more' ~ 5,
           is.na(c5) ~ 0
         )) %>% 
  mutate(across(committed:conformist, ~if_else(.x == 'Selected', 1, 0)))

################################################################################
## 1. Tablas por filtros -------------------------------------------------------
################################################################################


# 1.1. Por país -----------------------------------------------------------

# Suma por país
# sum_tbl <-
  ola_1 %>% 
  select(folio, country_2, 
         committed:conformist, # segment
         s1, # age group
         s2, #gender
         c5, # no. of people in hh
         c3:c7 # marital status, people in hh, residency type, education lvl
         ) %>% 
  fastDummies::dummy_cols(select_columns = c('s1', 's2' , 'c3', 'c6', 'c7')) %>% 
  select(-s1, -s2, -c6, -c7, -c3) %>%
  janitor::clean_names() %>% 
  mutate(across(c4_a:c4_i, ~if_else(. == 'Yes', 1, 0))) %>% 
  group_by(country_2) %>% 
  summarise(across(c(committed:c7_other), ~sum(.x))) #%T>% write_clip()



# Total por columnas
sum_tbl %>% 
  summarise(across(committed:c7_other, ~sum(.x))) %T>%
  write_clip()


# 1.2.1 Por bebidas consumidas -----------------------------------------------

base_pre <- 
  ola_1 %>% 
  select(folio, country_2, 
         committed:conformist, # segment
         s1, # age group
         s2, #gender
         c5, # no. of people in hh
         c3:c7, # marital status, people in hh, residency type, education lvl
         s7_aa:s7_ct # Bebidas consumidas en p4w
  )

  

  # fastDummies::dummy_cols(select_columns = c('s1', 's2' , 'c3', 'c6', 'c7')) %>% 
  # select(-s1, -s2, -c6, -c7, -c3) %>%
  # janitor::clean_names() %>% 
  # mutate(across(c4_a:c4_i, ~if_else(. == 'Yes', 1, 0))) %>% 
  # group_by(country_2) %>% 
  # summarise(across(c(committed:c7_other), ~sum(.x))) #%T>% write_clip()
  

################################################################################
## 2. Tablas por preguntas -----------------------------------------------------
################################################################################
  

# 2.1.1. Q1 Most recent beverage/snack -----------------------------------------
  
base_pre <- 
  ola_1 %>% 
  select(folio,
         cell, #Beverages (A) or snack (B)
         country_2, 
         committed:conformist, # segment
         s1, # age group
         s2, #gender
         c5, # no. of people in hh
         c3:c7, # marital status, people in hh, residency type, education lvl
         q1_1
  )


# 2.1.2. Beverages -------------------------------------------------------

# n = 2600
base_pre %<>% 
  filter(cell == 'A') %>% 
  select(-cell)

base_pre %>% 
  fastDummies::dummy_cols(select_columns = c('s1', 's2', 'c3', 
                                             'c6', 'c7', 'country_2')) %>% 
  select(-s1, -s2, -c6, -c7, -c3, -country_2, -`s2_Other (Please write in)`) %>%
  janitor::clean_names() %>% 
  mutate(across(c4_a:c4_i, ~if_else(. == 'Yes', 1, 0))) %>% 
  group_by(q1_1) %>% 
  summarise(across(c(committed:country_2_thailand), ~sum(.x))) %>% 
  ordenador() %>% 
  select(Beverage = q1_1, everything()) %T>% write_clip()
        
  

# 2.2.1. Q2 Phrase association --------------------------------------------

base_pre <- 
  ola_1 %>% 
  select(folio,
         cell, #Beverages (A) or snack (B)
         country_2, 
         committed:conformist, # segment
         s1, # age group
         s2, #gender
         c5, # no. of people in hh
         c3:c7, # marital status, people in hh, residency type, education lvl
         q2_2_a:q2_2_z,
         q3a_1, q3a_2
  )

freq_tbl <- 
  base_pre %>% 
  pivot_longer(q2_2_a:q2_2_z, 
               names_to = 'preg',
               values_to = 'resp') %>% 
  mutate(resp = if_else(resp == 'Yes', 1, 0),
         letra = str_extract(preg, '\\w$')) %>%
  left_join(cat_q2) %>%
  select(-preg, -letra) %>% 
  select(folio, resp, Phrase, q3a_2) %>% 
  na.omit() %>% 
  mutate(brand_aff = ifelse(q3a_2 == 'I love it', 1, 0)) %>% 
  pivot_wider(names_from = Phrase,
              values_from = resp) %>% 
  select(-folio, -q3a_2)
  # group_by(Phrase) %>% 
  # summarise(freq = sum(resp, na.rm = T)) %>% 
  # pivot_wider(names_from = country_2, 
  #             values_from = freq) %>% 
  # ungroup()

# Paso 1: Obtener matriz de correlación

cor_mtx <- 
  freq_tbl %>% 
  # as.data.frame() %>% 
  # set_rownames(.$Phrase) %>% 
  # select(-Phrase) %>% 
  # as.matrix() %>% 
  cor()

# Paso 2: Obtener eigenvectores

eigen_mtx <- 
  eigen(cor_mtx)

# Paso 3: Obtener matriz diagonal de los eigenvalores y sacarle raíz

diag_mtx <- 
  eigen_mtx$values %>% 
  diag() %>% 
  sqrt()

# Paso 4: Calcular el producto matriz de eigenvalores con su transpuesta

A <- 
  eigen_mtx$vectors %*% diag_mtx %*% t(eigen_mtx$vectors) 


# Paso 5: Elevar al cuadrado la matriz 

B <- 
  A*A

# Paso 6: Calcular el efecto parcial de cada variable independiente.
#         Se calcula multiplicando la inversa de la matriz A y la matriz de correlación.

partial_fx <- 
  solve(A) %*% cor_mtx[1,]

# Paso 7: Cálculo de la R^2

sum(partial_fx)

# Paso 8: Calcular los pesos multiplicando B por el cuadrado de partial_fx

wts_mtx <- 
  B %*% (partial_fx^2)

wts_mtx %>%  
  as_tibble()

# Paso 9: Calcular los pesos como medida de la R^2 dividiendo por la R^2 y mult. por 100

wts_mtx %>% 
  as_tibble() %>% 
  mutate(V1 = V1 / sum(partial_fx) * 100)

