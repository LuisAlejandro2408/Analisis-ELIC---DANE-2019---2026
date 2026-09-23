
# 🏗️ Caso de Estudio DANE: Análisis del Comportamiento Regional de las Licencias de Construcción (ELIC) en Colombia (2019 – 2026)

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

**Autor:** Luis Alejandro Alarcón Vargas  
**Fecha:** Junio 2026  
**Fuente de datos:** [DANE - Estadística de Licencias de Construcción (ELIC)](https://www.dane.gov.co/)

---

## 📌 Pregunta Clave del Proyecto
> *¿Cómo se distribuyen geográficamente las licencias de construcción aprobadas en los departamentos y municipios de Colombia, qué revela la relación VIS / No VIS sobre la oferta de vivienda social por región, y qué destinos de construcción predominan en cada zona del país?*

---

## 📝 Descripción del Proyecto

La **Estadística de Licencias de Construcción (ELIC)** es la operación oficial realizada mensualmente por el **DANE** en Colombia. Registra el área ($m^2$) y el número de unidades de vivienda formalmente aprobadas por curadurías urbanas y oficinas de planeación municipal. 

*Nota importante:* ELIC mide la **intención formal de construir** (permisos aprobados) y no necesariamente la obra física ejecutada.

A partir de enero de 2019, el DANE amplió su cobertura a más de **1.000 municipios**, permitiendo por primera vez una visión geográfica integral de la actividad constructora del país. En este proyecto se procesaron y analizaron más de **170.000 registros de licencias aprobadas** entre enero de 2019 y abril de 2026.

---

## 🛠️ Tecnologías y Herramientas Utilizadas

* **Python & Pandas:** Extracción de datos vía API/Excel, decodificación de variables categóricas, estandarización de códigos DIVIPOLA y tratamiento de coberturas históricas.
* **PostgreSQL & SQL:** Modelamiento relacional (Tablas de Hechos y Dimensiones) y consultas analíticas agregadas (`JOIN`, `GROUP BY`, funciones de ventana `OVER(PARTITION BY)`).
* **Power BI:** Construcción de Dashboard interactivo con métricas DAX y geolocalización de proyectos.

---

## ⚙️ Flujo del Proyecto (Metodología)

1. **Preguntar:** Definición de preguntas clave y stakeholders del sector (DANE, analistas económicos, entidades territoriales).
2. **Preparar:** Carga y validación del archivo de serie tipo base del DANE bajo el marco de calidad ROCCC.
3. **Procesar:** 
   * Asignación de tipos de datos adecuados (mantenimiento de ceros a la izquierda en códigos DIVIPOLA de 5 dígitos).
   * Decodificación de variables estructurales (destino, clase de suelo, estrato, tipo de vivienda, VIS/No VIS).
   * Filtrado espacial para asegurar comparabilidad geográfica (1.078 municipios analizados).
4. **Analizar:** Carga de datos estructurados en PostgreSQL para el cálculo de KPIs estratégicos.
5. **Compartir:** Creación de tablero analítico en Power BI y documentación de hallazgos.

---

## 💡 Hallazgos Principales

1. **Alta Concentración Geográfica:**
   * Cuatro departamentos (**Antioquia, Bogotá D.C., Cundinamarca y Valle del Cauca**) concentran **más del 50% de todo el área licenciada** aprobada en el país durante el periodo 2019–2026.
2. **Dominio de Bogotá D.C.:**
   * A nivel municipal, Bogotá lidera ampliamente el volumen de área aprobada, superando por más de 4 veces a las ciudades que le siguen (Cali y Medellín).
3. **Composición de la Oferta:**
   * El destino **Vivienda** es el motor predominante de la construcción licenciada a nivel nacional y departamental, muy por encima de destinos comerciales o industriales.
   * La vivienda **No VIS** mantiene la mayor participación del mercado residencial, seguida por la vivienda **VIS**, mientras que la categoría **VIP** mantiene una representación marginal.

---

## 📁 Estructura del Repositorio

## 📁 Estructura del Repositorio

```text
.
├── elic_dane.ipynb          # Notebook de Jupyter con la extracción (ETL), procesamiento y análisis exploratorio
├── consultas_dane_elic.sql  # Consultas SQL ejecutadas en PostgreSQL para el análisis de datos
├── ELIC_DANE.pbix           # Archivo fuente del Dashboard interactivo en Power BI
├── ELIC_DANE.pdf            # Exportación en PDF del reporte de Power BI
└── README.md                # Documentación del proyecto
