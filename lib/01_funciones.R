################################################################################
## Descripción: Funciones y catálogos útiles para Sonic
## Autor: Edmar Trápaga Vieyra
## Fecha: 27 de mayo de 2021
################################################################################

ordenador <- function(base){
  
  base_sin_ordenar <- base
  
  base_ordenada <- 
    base_sin_ordenar %>% 
    select(UK = country_2_uk,
           Germany = country_2_germany,
           USA = country_2_usa,
           Nigeria = country_2_nigeria,
           India = country_2_india,
           Saudi = country_2_saudi,
           China = country_2_china,
           Thailand = country_2_thailand,
           Mexico = country_2_mexico,
           Brazil = country_2_brazil,
           '16 to 24' = s1_16_24,
           '25 to 34' = s1_25_34,
           '35 to 54' = s1_35_54,
           unwilling,
           uninformed = conformist,
           pragmatic,
           weary,
           concerned,
           committed,
           Male = s2_male,
           Female = s2_female,
           Single = c3_single,
           'Married/Co-habiting' = c3_married_co_habiting,
           'Divorced/Separated/Widowed' = c3_divorced_separated_widowed,
           'I live alone' = c4_a,
           'Partner/Spouse' = c4_b,
           'Children aged under 3'= c4_c,
           'Children aged 4-6' = c4_d,
           'Children aged 7-12' = c4_e,
           'Children aged 13-17' = c4_f,
           'Children aged 18+' = c4_g,
           'Parents/Grandparents' = c4_h,
           'Other adults' = c4_i,
           'NET: Children in h/h' = c5,
           'In the countryside' = c6_in_the_countryside,
           'In a small town or village' = c6_in_a_small_town_or_village,
           'In the suburbs of a large town or city' = c6_in_the_suburbs_of_a_large_town_or_city,
           'In a large town or city' = c6_in_a_large_town_or_city,
           'High school or less' = c7_high_school_or_less,
           'College, no degree' = c7_college_no_degree,
           "Associate or Bachelor's degree" = c7_associate_or_bachelors_degree,
           'Masters or Doctorate degree' = c7_masters_or_doctorate_degree,
           'Other' = c7_other,
           everything()
    )
  
  return(base_ordenada)
           
}
