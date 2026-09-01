# ============================================================
# PROYECTO DE CIENCIA DE DATOS REPRODUCIBLE - GAPMINDER
# Código de importación y depuración de datos
# ============================================================

# Autora: Alicia Palomar Ramos
# Fuente de datos: Gapminder
# Indicadores:
# - GDP per capita
# - Life expectancy
# - Babies per woman
# - Population
#
# El objetivo de este script es importar, revisar,
# transformar y depurar los datos para su posterior análisis.
# ============================================================
# 1. CARGA DE LIBRERÍAS
# ============================================================

library(readr)
library(dplyr)
library(tidyr)
library(tidyverse)
# ============================================================
# 2. IMPORTACIÓN DE LOS DATOS ORIGINALES
##Importamos las 4 bases de datos que vamos a utilizar: GDP per cápita, Esperanza de Vida, Población y 
# ============================================================

# GDP per cápita
gdp <- read_csv("Datos/Base de datos original/gdp_pcap.csv")

# Esperanza de vida
life <- read_csv("Datos/Base de datos original/lex.csv")

# Población
population <- read_csv("Datos/Base de datos original/pop.csv")

# Tasa de fertilidad (hijos por mujer)
babies <- read_csv("Datos/Base de datos original/children_per_woman_total_fertility.csv")

# ============================================================
# 3. COMPROBACIÓN INICIAL DE LOS DATOS
# ============================================================

# Dimensiones de las bases
dim(gdp)
dim(life)
dim(population)
dim(babies)

# Estructura de las bases
glimpse(gdp)
glimpse(life)
glimpse(population)
glimpse(babies)

# Comprobamos los nombres de las variables

names(gdp)
names(life)
names(population)
names(babies)

# ============================================================
# 4. COMPROBACIÓN DE LOS AÑOS DISPONIBLES
# ============================================================

# Extraemos los nombres de las columnas correspondientes a los años.
# Las dos primeras columnas corresponden a geo y name.

years_gdp <- names(gdp)[-(1:2)]
years_life <- names(life)[-(1:2)]
years_population <- names(population)[-(1:2)]
years_babies <- names(babies)[-(1:2)]


# Comprobamos si las cuatro bases contienen los mismos años

identical(years_gdp, years_life)
identical(years_gdp, years_population)
identical(years_gdp, years_babies)

# ============================================================
# 5. COMPROBACIÓN DE LOS TIPOS DE DATOS
# ============================================================

str(gdp)
str(life)
str(population)
str(babies)

##Comprobamos las dos variables identificativas

class(gdp$geo)
class(gdp$name)

class(life$geo)
class(life$name)

class(population$geo)
class(population$name)

class(babies$geo)
class(babies$name)

### Las variables geo y name son de tipo carácter (chr), mientras que
# las variables correspondientes a los años son numéricas (num).
# La estructura es adecuada para realizar posteriormente el análisis.

# ============================================================
# 6. COMPROBACIÓN DE IDENTIFICADORES Y DUPLICADOS
# ============================================================

# Comprobamos que no existen identificadores geo duplicados
anyDuplicated(gdp$geo)
anyDuplicated(life$geo)
anyDuplicated(population$geo)
anyDuplicated(babies$geo)

# Comprobamos que no existen nombres de territorios duplicados
anyDuplicated(gdp$name)
anyDuplicated(life$name)
anyDuplicated(population$name)
anyDuplicated(babies$name)

# ============================================================
# 7. COMPROBACIÓN DE VALORES AUSENTES
# ============================================================

#Esta comprobación permite identificar las variables
# que requieren especial atención durante la depuración.

# Comprobamos el número total de valores ausentes por base.
sum(is.na(gdp))
sum(is.na(life))
sum(is.na(population))
sum(is.na(babies))

# Los conjuntos GDP per capita y Babies per woman no presentan valores ausentes.
# Life expectancy presenta 1.577 valores ausentes y Population 100.


# Identificamos los territorios que presentan al menos un valor ausente
# en las variables de esperanza de vida y población.

life_na <- life %>%
  filter(if_any(all_of(years_life), is.na)) %>%
  select(geo, name)

population_na <- population %>%
  filter(if_any(all_of(years_population), is.na)) %>%
  select(geo, name)

# Mostramos los territorios afectados
life_na
population_na

# Los valores ausentes de esperanza de vida se concentran en 10 territorios,
# mientras que en población únicamente aparece un territorio afectado.

# ============================================================
# 7.1. DISTRIBUCIÓN TEMPORAL DE LOS VALORES AUSENTES
# ============================================================

# Comprobamos cuántos valores ausentes existen en cada año.

na_life_year <- colSums(is.na(life[years_life]))
na_population_year <- colSums(is.na(population[years_population]))

na_life_year[na_life_year > 0]
na_population_year[na_population_year > 0]

# Los valores ausentes de esperanza de vida se concentran en dos periodos:
# de 1800 a 1949 afectan a 10 territorios y de 2024 a 2100 afectan a 1 territorio.
# En población, los valores ausentes aparecen desde 2001 hasta 2100
# y corresponden a un único territorio.

# ============================================================
# 7.2. NÚMERO DE VALORES AUSENTES POR TERRITORIO
# ============================================================

# Contamos los valores ausentes de cada territorio.

na_life_country <- life %>%
  mutate(na_count = rowSums(is.na(across(all_of(years_life))))) %>%
  filter(na_count > 0) %>%
  select(geo, name, na_count)

na_population_country <- population %>%
  mutate(na_count = rowSums(is.na(across(all_of(years_population))))) %>%
  filter(na_count > 0) %>%
  select(geo, name, na_count)

# Mostramos los territorios afectados y el número de valores ausentes.
na_life_country
na_population_country

# Los valores ausentes de esperanza de vida se concentran en 10 territorios.
# La mayoría presentan 150 valores ausentes, mientras que Liechtenstein
# presenta 227. En población, los 100 valores ausentes corresponden
# únicamente a Holy See.

# ============================================================
# 7.3. REVISIÓN DE LOS PERIODOS CON VALORES AUSENTES
# ============================================================

# Identificamos el primer y último año con datos disponibles
# para cada territorio afectado.

life_periods <- life %>%
  filter(geo %in% life_na$geo) %>%
  rowwise() %>%
  mutate(
    first_year = min(as.numeric(years_life)[!is.na(c_across(all_of(years_life)))], na.rm = TRUE),
    last_year = max(as.numeric(years_life)[!is.na(c_across(all_of(years_life)))], na.rm = TRUE)
  ) %>%
  ungroup() %>%
  select(geo, name, first_year, last_year)

population_periods <- population %>%
  filter(geo %in% population_na$geo) %>%
  rowwise() %>%
  mutate(
    first_year = min(as.numeric(years_population)[!is.na(c_across(all_of(years_population)))], na.rm = TRUE),
    last_year = max(as.numeric(years_population)[!is.na(c_across(all_of(years_population)))], na.rm = TRUE)
  ) %>%
  ungroup() %>%
  select(geo, name, first_year, last_year)

# Mostramos los periodos disponibles
life_periods
population_periods

# Los territorios afectados en esperanza de vida disponen de datos
# a partir de 1950. Por tanto, los valores ausentes anteriores a ese año
# corresponden a un periodo sin datos disponibles.
#
# Liechtenstein presenta además valores ausentes desde 2024 hasta 2100.
#
# En población, Holy See dispone de datos hasta el año 2000,
# mientras que los años posteriores presentan valores ausentes.

# ============================================================
# 7.4. COMPROBACIÓN DE VALORES AUSENTES AISLADOS
# ============================================================

# Comprobamos si existen valores ausentes dentro de periodos
# en los que el territorio sí dispone de información.

life %>%
  filter(geo %in% life_na$geo) %>%
  rowwise() %>%
  mutate(
    na_between = sum(
      is.na(c_across(all_of(years_life)))[
        min(which(!is.na(c_across(all_of(years_life))))) :
          max(which(!is.na(c_across(all_of(years_life)))))
      ]
    )
  ) %>%
  ungroup() %>%
  select(geo, name, na_between)

population %>%
  filter(geo %in% population_na$geo) %>%
  rowwise() %>%
  mutate(
    na_between = sum(
      is.na(c_across(all_of(years_population)))[
        min(which(!is.na(c_across(all_of(years_population))))) :
          max(which(!is.na(c_across(all_of(years_population)))))
      ]
    )
  ) %>%
  ungroup() %>%
  select(geo, name, na_between)

# No se detectan valores ausentes aislados dentro de los periodos
# con información disponible. Los valores ausentes forman bloques
# completos al inicio o al final de las series temporales.

# ============================================================
# 8. SELECCIÓN DEL PERIODO DE ANÁLISIS
# ============================================================

# Para definir el periodo de análisis se comprueba la disponibilidad
# de datos en las cuatro bases y se considera el periodo común con
# información suficiente para las variables que se van a analizar.

# Comprobamos el número de valores ausentes entre 1990 y 2019
years_analysis <- as.character(1990:2019)

na_1990_2019 <- data.frame(
  GDP = sum(is.na(gdp[years_analysis])),
  Life = sum(is.na(life[years_analysis])),
  Population = sum(is.na(population[years_analysis])),
  Babies = sum(is.na(babies[years_analysis]))
)

na_1990_2019

# Comprobamos en qué territorios se encuentran los valores ausentes
# de Population dentro del periodo 1990-2019.

population_na_1990_2019 <- population %>%
  select(geo, name, all_of(years_analysis)) %>%
  filter(if_any(all_of(years_analysis), is.na))

population_na_1990_2019

# Contamos los valores ausentes de cada territorio dentro del periodo
# seleccionado.

population_na_1990_2019_count <- population %>%
  select(geo, name, all_of(years_analysis)) %>%
  filter(if_any(all_of(years_analysis), is.na)) %>%
  rowwise() %>%
  mutate(na_count = sum(is.na(c_across(all_of(years_analysis))))) %>%
  ungroup() %>%
  select(geo, name, na_count)

population_na_1990_2019_count

# Los 19 valores ausentes de Population dentro del periodo 1990-2019
# corresponden exclusivamente a Holy See.
# Al tratarse de un territorio sin información de población durante
# parte del periodo y no de valores ausentes aislados, se excluirá
# posteriormente del conjunto de datos final para evitar realizar
# imputaciones que podrían introducir valores artificiales.

#################El periodo de análisis se establece entre 1990 y 2019.
# Este periodo permite trabajar con las cuatro variables seleccionadas
# y evita los periodos con una mayor presencia de valores ausentes.
# La única excepción dentro del periodo es Holy See en Population,
# que será excluido posteriormente del conjunto final.