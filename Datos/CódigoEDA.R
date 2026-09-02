# ============================================================
# PROYECTO DE CIENCIA DE DATOS REPRODUCIBLE - GAPMINDER
# ANÁLISIS EXPLORATORIO DE DATOS (EDA)
# ============================================================

# Autora: Alicia Palomar Ramos
#
# El objetivo de este script es explorar la base de datos
# previamente depurada y estudiar las características principales
# de las variables seleccionadas, así como sus relaciones y
# evolución temporal.
#
# La depuración de los datos se realiza previamente en:
# codigo_depuracion.R
#
# Base utilizada:
# Datos/Base de datos depurada/data_final.csv
#
# Variables:
# - GDP per capita
# - Life expectancy
# - Babies per woman
# - Population
#
# Periodo: 1990-2019
# ============================================================


# ============================================================
# 1. CARGA DE LIBRERÍAS
# ============================================================

library(readr)
library(dplyr)
library(ggplot2)


# ============================================================
# 2. CARGA DE LA BASE DE DATOS DEPURADA
# ============================================================

# Cargamos la base de datos resultante del proceso de
# importación y depuración.

data_final <- read_csv(
  "Datos/Base de datos depurada/data_final.csv"
)


# ============================================================
# 3. EXPLORACIÓN BÁSICA
# ============================================================

# Comprobamos las dimensiones de la base.

dim(data_final)

# Comprobamos la estructura de las variables.

glimpse(data_final)

# Mostramos un resumen estadístico de las variables.

summary(data_final)

# Comprobamos el número de territorios y años.

n_distinct(data_final$geo)
n_distinct(data_final$year)

# Comprobamos el periodo disponible.

range(data_final$year)


# ============================================================
# 4. ESTADÍSTICOS DESCRIPTIVOS
# ============================================================

# Calculamos algunos estadísticos descriptivos para las
# cuatro variables principales.

estadisticos <- data_final %>%
  summarise(
    GDP_media = mean(gdp),
    GDP_mediana = median(gdp),
    
    Life_media = mean(life),
    Life_mediana = median(life),
    
    Babies_media = mean(babies),
    Babies_mediana = median(babies),
    
    Population_media = mean(population),
    Population_mediana = median(population)
  )

estadisticos


# También calculamos mínimo y máximo.

rangos <- data_final %>%
  summarise(
    GDP_min = min(gdp),
    GDP_max = max(gdp),
    
    Life_min = min(life),
    Life_max = max(life),
    
    Babies_min = min(babies),
    Babies_max = max(babies),
    
    Population_min = min(population),
    Population_max = max(population)
  )

rangos


# ============================================================
# 5. EVOLUCIÓN TEMPORAL
# ============================================================

# Calculamos la mediana de cada variable para cada año.
#
# Utilizamos la mediana porque las variables presentan
# distribuciones muy diferentes entre territorios y algunas
# pueden estar influenciadas por valores extremos.

evolucion <- data_final %>%
  group_by(year) %>%
  summarise(
    GDP = median(gdp),
    Life = median(life),
    Babies = median(babies),
    Population = median(population)
  )


# ------------------------------------------------------------
# 5.1. Evolución de la esperanza de vida
# ------------------------------------------------------------

ggplot(evolucion, aes(x = year, y = Life)) +
  geom_line() +
  labs(
    title = "Evolución de la esperanza de vida",
    x = "Año",
    y = "Esperanza de vida (años)"
  )


# ------------------------------------------------------------
# 5.2. Evolución de la fertilidad
# ------------------------------------------------------------

ggplot(evolucion, aes(x = year, y = Babies)) +
  geom_line() +
  labs(
    title = "Evolución de la fertilidad",
    x = "Año",
    y = "Hijos por mujer"
  )


# ------------------------------------------------------------
# 5.3. Evolución del GDP per capita
# ------------------------------------------------------------

ggplot(evolucion, aes(x = year, y = GDP)) +
  geom_line() +
  scale_y_log10() +
  labs(
    title = "Evolución del GDP per capita",
    x = "Año",
    y = "GDP per capita (escala logarítmica)"
  )


# ------------------------------------------------------------
# 5.4. Evolución de la población
# ------------------------------------------------------------

ggplot(evolucion, aes(x = year, y = Population)) +
  geom_line() +
  scale_y_log10() +
  labs(
    title = "Evolución de la población",
    x = "Año",
    y = "Población (escala logarítmica)"
  )


# ============================================================
# 6. RELACIONES ENTRE VARIABLES
# ============================================================

# Para estudiar las relaciones entre variables utilizamos
# inicialmente el año 2019, que corresponde al último año
# del periodo seleccionado.

datos_2019 <- data_final %>%
  filter(year == 2019)


# ------------------------------------------------------------
# 6.1. GDP per capita y esperanza de vida
# ------------------------------------------------------------

ggplot(datos_2019, aes(x = gdp, y = life)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_x_log10() +
  labs(
    title = "Relación entre GDP per capita y esperanza de vida",
    subtitle = "Año 2019",
    x = "GDP per capita (escala logarítmica)",
    y = "Esperanza de vida (años)"
  )


# ------------------------------------------------------------
# 6.2. Fertilidad y esperanza de vida
# ------------------------------------------------------------

ggplot(datos_2019, aes(x = babies, y = life)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(
    title = "Relación entre fertilidad y esperanza de vida",
    subtitle = "Año 2019",
    x = "Hijos por mujer",
    y = "Esperanza de vida (años)"
  )


# ------------------------------------------------------------
# 6.3. GDP per capita y fertilidad
# ------------------------------------------------------------

ggplot(datos_2019, aes(x = gdp, y = babies)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_x_log10() +
  labs(
    title = "Relación entre GDP per capita y fertilidad",
    subtitle = "Año 2019",
    x = "GDP per capita (escala logarítmica)",
    y = "Hijos por mujer"
  )


# ============================================================
# 7. CORRELACIONES
# ============================================================

# Calculamos las correlaciones entre las variables principales.
#
# Estas correlaciones permiten complementar la exploración
# gráfica de las relaciones entre las variables.

correlaciones <- datos_2019 %>%
  select(gdp, life, babies, population) %>%
  cor()

correlaciones


# ============================================================
# 8. CONCLUSIONES DEL EDA
# ============================================================

# Los principales resultados obtenidos mediante este análisis
# exploratorio se utilizarán para definir los contenidos del
# dashboard y del informe técnico.
#
# El EDA permite analizar:
#
# - La distribución general de las cuatro variables.
# - Su evolución durante el periodo 1990-2019.
# - La relación entre GDP per capita y esperanza de vida.
# - La relación entre fertilidad y esperanza de vida.
# - La relación entre GDP per capita y fertilidad.
# - Las correlaciones entre las variables en 2019.
#
# Estos resultados servirán como punto de partida para
# desarrollar el dashboard y seleccionar los principales
# hallazgos que se presentarán en el informe técnico.