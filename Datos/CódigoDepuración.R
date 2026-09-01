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

# ============================================================
# 9. DEPURACIÓN DE LOS DATOS
# ============================================================

# Seleccionamos el periodo de análisis establecido: 1990-2019.
# Se conservan las variables identificativas geo y name y los
# valores correspondientes a los años seleccionados.

years_analysis <- as.character(1990:2019)

gdp_clean <- gdp %>%
  select(geo, name, all_of(years_analysis))

life_clean <- life %>%
  select(geo, name, all_of(years_analysis))

population_clean <- population %>%
  select(geo, name, all_of(years_analysis))

babies_clean <- babies %>%
  select(geo, name, all_of(years_analysis))

# ============================================================
# 9.1. COMPROBACIÓN DE VALORES AUSENTES TRAS SELECCIONAR
# EL PERIODO DE ANÁLISIS
# ============================================================

# Comprobamos que no quedan valores ausentes en las bases,
# excepto el caso de Holy See identificado anteriormente.

sum(is.na(gdp_clean))
sum(is.na(life_clean))
sum(is.na(population_clean))
sum(is.na(babies_clean))

# ============================================================
# 9.2. TRATAMIENTO DE LOS VALORES AUSENTES DE POBLACIÓN
# ============================================================

# Los 19 valores ausentes de Population corresponden a Holy See.
# Al tratarse de un bloque de valores ausentes y no de valores
# aislados, se excluye este territorio del análisis en lugar de
# realizar una imputación.

population_clean <- population_clean %>%
  filter(geo != "hos")

# Comprobamos que Holy See ya no forma parte de la base.
population_clean %>%
  filter(geo == "hos")

# Comprobamos que no quedan valores ausentes.
sum(is.na(population_clean))

# ============================================================
# 9.3. COMPROBACIÓN DE LOS TERRITORIOS TRAS LA DEPURACIÓN
# ============================================================

# Comprobamos que las cuatro bases contienen los mismos territorios.

setdiff(gdp_clean$geo, life_clean$geo)
setdiff(gdp_clean$geo, population_clean$geo)
setdiff(gdp_clean$geo, babies_clean$geo)

setdiff(life_clean$geo, gdp_clean$geo)
setdiff(population_clean$geo, gdp_clean$geo)
setdiff(babies_clean$geo, gdp_clean$geo)

# Comprobamos qué territorios aparecen en GDP
# y que no están presentes en las demás bases.

gdp_clean %>%
  filter(geo %in% c("lie", "hos"))

life_clean %>%
  filter(geo %in% c("lie", "hos"))

population_clean %>%
  filter(geo %in% c("lie", "hos"))

babies_clean %>%
  filter(geo %in% c("lie", "hos"))

# Comprobamos el número de territorios disponibles en cada base.

nrow(gdp_clean)
nrow(life_clean)
nrow(population_clean)
nrow(babies_clean)

# ============================================================
# 9.4.COMPROBACIÓN DE TERRITORIOS COMUNES
# ============================================================

# Identificamos los territorios presentes en las cuatro bases.
common_geo <- Reduce(
  intersect,
  list(
    gdp_clean$geo,
    life_clean$geo,
    population_clean$geo,
    babies_clean$geo
  )
)

# Comprobamos cuántos territorios están presentes en las cuatro bases.
length(common_geo)

# Comprobamos qué territorios quedarán disponibles para el análisis.
common_geo

# Los cuatro conjuntos de datos comparten 193 territorios.
# Los territorios que no están presentes en las cuatro bases
# se excluirán del conjunto final para garantizar que todas las
# variables analizadas correspondan a los mismos territorios.

# ============================================================
# 9.5. HOMOGENEIZACIÓN DE LOS TERRITORIOS
# ============================================================

# Conservamos únicamente los territorios presentes en las cuatro bases.

gdp_clean <- gdp_clean %>%
  filter(geo %in% common_geo)

life_clean <- life_clean %>%
  filter(geo %in% common_geo)

population_clean <- population_clean %>%
  filter(geo %in% common_geo)

babies_clean <- babies_clean %>%
  filter(geo %in% common_geo)

# Comprobamos que todas las bases tienen el mismo número de territorios.

nrow(gdp_clean)
nrow(life_clean)
nrow(population_clean)
nrow(babies_clean)

# Las cuatro bases contienen ahora los mismos 193 territorios,
# por lo que pueden combinarse de forma consistente.

# Comprobamos que los territorios coinciden exactamente y están
# en el mismo orden en las cuatro bases.

identical(gdp_clean$geo, life_clean$geo)
identical(gdp_clean$geo, population_clean$geo)
identical(gdp_clean$geo, babies_clean$geo)

# ============================================================
# 10. TRANSFORMACIÓN A FORMATO LARGO
# ============================================================

# Transformamos las bases de formato ancho a formato largo.
# Cada fila representará un territorio y un año.

gdp_long <- gdp_clean %>%
  pivot_longer(
    cols = all_of(years_analysis),
    names_to = "year",
    values_to = "gdp"
  )

life_long <- life_clean %>%
  pivot_longer(
    cols = all_of(years_analysis),
    names_to = "year",
    values_to = "life"
  )

population_long <- population_clean %>%
  pivot_longer(
    cols = all_of(years_analysis),
    names_to = "year",
    values_to = "population"
  )

babies_long <- babies_clean %>%
  pivot_longer(
    cols = all_of(years_analysis),
    names_to = "year",
    values_to = "babies"
  )

# Convertimos el año a formato numérico.

gdp_long$year <- as.numeric(gdp_long$year)
life_long$year <- as.numeric(life_long$year)
population_long$year <- as.numeric(population_long$year)
babies_long$year <- as.numeric(babies_long$year)

# Comprobamos la estructura de las nuevas bases.

glimpse(gdp_long)
glimpse(life_long)
glimpse(population_long)
glimpse(babies_long)

# El formato largo facilita la combinación de las cuatro variables
# y permite realizar posteriormente análisis y visualizaciones
# utilizando el año como una variable.

# ============================================================
# 10.1. COMPROBACIÓN DE LA TRANSFORMACIÓN
# ============================================================

# Comprobamos que cada base contiene 193 territorios y 30 años.
nrow(gdp_long)
nrow(life_long)
nrow(population_long)
nrow(babies_long)

# Comprobamos que no existen valores ausentes después de la depuración.
sum(is.na(gdp_long))
sum(is.na(life_long))
sum(is.na(population_long))
sum(is.na(babies_long))

# Comprobamos que cada territorio tiene 30 observaciones,
# una por cada año del periodo 1990-2019.

table(table(gdp_long$geo))
table(table(life_long$geo))
table(table(population_long$geo))
table(table(babies_long$geo))

# ============================================================
# 10.2. COMPROBACIÓN DE IDENTIFICADORES
# ============================================================

# Cada combinación de territorio y año debe aparecer una única vez.

anyDuplicated(gdp_long[, c("geo", "year")])
anyDuplicated(life_long[, c("geo", "year")])
anyDuplicated(population_long[, c("geo", "year")])
anyDuplicated(babies_long[, c("geo", "year")])

# ============================================================
# 11. COMPROBACIÓN DE LAS OBSERVACIONES A COMBINAR
# ============================================================

# Comprobamos que las cuatro bases tienen las mismas combinaciones
# de territorio y año.

setdiff(
  gdp_long[, c("geo", "year")],
  life_long[, c("geo", "year")]
)

setdiff(
  gdp_long[, c("geo", "year")],
  population_long[, c("geo", "year")]
)

setdiff(
  gdp_long[, c("geo", "year")],
  babies_long[, c("geo", "year")]
)

setdiff(
  life_long[, c("geo", "year")],
  gdp_long[, c("geo", "year")]
)

setdiff(
  population_long[, c("geo", "year")],
  gdp_long[, c("geo", "year")]
)

setdiff(
  babies_long[, c("geo", "year")],
  gdp_long[, c("geo", "year")]
)

# ============================================================
# 12. UNIÓN DE LAS CUATRO BASES
# ============================================================

# Combinamos las cuatro bases utilizando geo y year como identificadores.

data_final <- gdp_long %>%
  left_join(
    life_long %>% select(geo, year, life),
    by = c("geo", "year")
  ) %>%
  left_join(
    population_long %>% select(geo, year, population),
    by = c("geo", "year")
  ) %>%
  left_join(
    babies_long %>% select(geo, year, babies),
    by = c("geo", "year")
  )

# Comprobamos la estructura del conjunto final.

glimpse(data_final)

# Comprobamos las dimensiones del conjunto final.
dim(data_final)

# Comprobamos que no quedan valores ausentes.
sum(is.na(data_final))

# Comprobamos que no existen duplicados de territorio y año.
anyDuplicated(data_final[, c("geo", "year")])

# Comprobamos el número de territorios.
n_distinct(data_final$geo)

# Comprobamos los años disponibles.
sort(unique(data_final$year))

# El conjunto final contiene 193 territorios para el periodo 1990-2019,
# con una observación por territorio y año.
# Las cuatro variables seleccionadas se encuentran integradas en una
# única base y no se presentan valores ausentes ni duplicados.
# Este conjunto constituye la base de datos depurada que se utilizará
# para el análisis y el dashboard.