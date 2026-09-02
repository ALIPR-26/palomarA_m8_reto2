# palomarA_m8_reto2

# Análisis de indicadores socioeconómicos y demográficos - Gapminder

## Descripción del proyecto

Este proyecto tiene como objetivo analizar la evolución y la relación entre diferentes indicadores socioeconómicos y demográficos a nivel mundial durante el periodo 1990-2019.

El análisis se realiza utilizando datos procedentes de Gapminder y se centra en cuatro indicadores principales:

- PIB per cápita.
- Esperanza de vida.
- Población.
- Hijos por mujer.

Las bases de datos originales se encuentran disponibles en:

[Gapminder Data](https://www.gapminder.org/data/)

El proyecto incluye un proceso de importación y depuración de los datos, un análisis exploratorio (EDA), un dashboard interactivo y la elaboración de un informe técnico y una presentación mediante R Markdown.

---

## Objetivo principal

Analizar la evolución y la relación entre diferentes indicadores socioeconómicos y demográficos a nivel mundial durante el periodo 1990-2019, utilizando datos de Gapminder.

### Objetivos específicos

- Analizar la evolución temporal de los indicadores.
- Estudiar la relación entre PIB per cápita y esperanza de vida.
- Analizar la relación entre fertilidad y esperanza de vida.
- Estudiar la relación entre PIB per cápita y fertilidad.
- Comparar los indicadores entre diferentes territorios.

---

## Datos

Los datos utilizados proceden de Gapminder.

Se partió de cuatro bases de datos correspondientes a los indicadores seleccionados. Estas bases fueron integradas y depuradas para obtener un único conjunto de datos final.

El conjunto de datos final contiene información sobre diferentes territorios para el periodo comprendido entre 1990 y 2019.

Los principales indicadores utilizados son:

| Indicador | Descripción |
|-----------|-------------|
| PIB per cápita | Producto interior bruto por habitante |
| Esperanza de vida | Esperanza de vida al nacer, expresada en años |
| Población | Número de habitantes |
| Hijos por mujer | Número medio de hijos por mujer |

---

## Estructura del repositorio

El repositorio está organizado de la siguiente manera:

```text
📁 Dashboard
   └── Código y archivos relacionados con el dashboard interactivo

📁 Datos
   └── Bases de datos originales y datos depurados

📁 Informe
   └── Informe técnico realizado mediante knitr

📁 Presentación
   └── Presentación realizada mediante R Markdown

📄 .gitignore
   └── Archivos y elementos que no deben incluirse en el repositorio

📄 README.md
   └── Documentación del proyecto

📄 palomarA_m8_reto2.Rproj
   └── Proyecto de RStudio
```

---

## Metodología

El proyecto se ha desarrollado siguiendo las siguientes etapas:

### 1. Importación de los datos

Se importaron cuatro bases de datos correspondientes a los indicadores seleccionados.

### 2. Depuración y preparación de los datos

Las bases de datos fueron revisadas, depuradas e integradas para obtener un único conjunto de datos final preparado para el análisis.

### 3. Análisis exploratorio de datos (EDA)

Se realizó un análisis exploratorio para estudiar las distribuciones de las variables, su evolución temporal y las relaciones entre los diferentes indicadores.

### 4. Visualización de los resultados

Se utilizaron diferentes gráficos para representar la evolución temporal de los indicadores y estudiar sus relaciones.

Entre las visualizaciones realizadas se incluye un gráfico de evolución temporal y un bubble plot que relaciona el PIB per cápita, la esperanza de vida, la población y el número de hijos por mujer.

### 5. Dashboard interactivo

A partir de los resultados obtenidos en el análisis exploratorio se desarrolló un dashboard interactivo que permite explorar los indicadores y comparar diferentes años y territorios.

Para ejecutarlo:

1. Abrir el proyecto `palomarA_m8_reto2.Rproj` en RStudio.
2. Abrir el archivo del dashboard situado en la carpeta `Dashboard`.
3. Ejecutar la aplicación desde RStudio.

El dashboard permite explorar los indicadores seleccionados y analizar su evolución y las relaciones entre ellos mediante diferentes elementos interactivos.

### 6. Informe técnico

Se elaboró un informe técnico mediante knitr en el que se presentan los principales resultados del análisis, incluyendo tablas, gráficos e interpretación.

### 7. Presentación

Se elaboró una presentación mediante R Markdown para resumir los objetivos, metodología, principales resultados y conclusiones del proyecto.

---

## Principales resultados

Los principales resultados obtenidos son:

- El **PIB per cápita** presenta una tendencia creciente durante el periodo 1990-2019.
- La **esperanza de vida** presenta una tendencia creciente.
- La **población** presenta una tendencia creciente.
- El número de **hijos por mujer** presenta una tendencia decreciente.
- En 2019 se observa una **relación positiva entre PIB per cápita y esperanza de vida**.
- Los territorios con menores niveles de PIB per cápita y esperanza de vida presentan, en general, **mayores niveles de fertilidad**.

---

## Tecnologías y paquetes utilizados

El proyecto se ha desarrollado utilizando **R** y **RStudio**.

Los principales paquetes utilizados son:

- `readr`: importación de datos.
- `dplyr`: manipulación y transformación de datos.
- `tidyr`: reorganización de los datos.
- `ggplot2`: creación de gráficos.
- `scales`: formato de valores numéricos.
- `here`: gestión de rutas de archivos y reproducibilidad.
- `knitr`: generación de documentos mediante R Markdown.
- `plotly`: creación de visualizaciones interactivas.

---

## Reproducibilidad

El proyecto está organizado para facilitar su reproducción.

Para reproducir el proyecto:

1. Clonar o descargar este repositorio.
2. Abrir el archivo `palomarA_m8_reto2.Rproj` mediante RStudio.
3. Instalar los paquetes necesarios si no están instalados.
4. Ejecutar el código de importación y depuración de los datos.
5. Ejecutar el código correspondiente al dashboard.
6. Generar el informe técnico mediante knitr.
7. Generar la presentación mediante R Markdown.

Las rutas de los archivos se gestionan mediante el paquete `here`, evitando utilizar rutas absolutas específicas de un ordenador.

---

## Productos del proyecto

El repositorio contiene los siguientes productos:

- **Dashboard:** aplicación interactiva para explorar los indicadores y comparar diferentes años y territorios.
- **Informe técnico:** documento realizado mediante  knitr con los principales resultados del análisis.
- **Presentación:** presentación realizada mediante R Markdown con los objetivos, metodología, resultados y conclusiones.
- **Datos:** bases de datos utilizadas y conjunto de datos final después del proceso de depuración.

---

## Conclusiones

El análisis realizado permite observar una evolución diferenciada de los indicadores socioeconómicos y demográficos durante el periodo 1990-2019.

El **PIB per cápita, la esperanza de vida y la población presentan una tendencia creciente**, mientras que el **número de hijos por mujer disminuye**.

Además, en 2019 se observa una relación positiva entre el PIB per cápita y la esperanza de vida. En general, los territorios con menores niveles de PIB per cápita y esperanza de vida presentan mayores niveles de fertilidad.

El dashboard permite profundizar en estos resultados y explorar las diferencias existentes entre los distintos territorios y años analizados.

---

## Autora

**Alicia Palomar**

Proyecto realizado como parte del Reto 2 del módulo 8 del Master de Behavioural Data Science