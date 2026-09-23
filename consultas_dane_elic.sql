-- Tabla de municipios (dimensión)
CREATE TABLE municipios (
    cod_dane VARCHAR(5) PRIMARY KEY,
    cod_depto VARCHAR(2),
    departamento VARCHAR(100),
    cod_muni VARCHAR(3),
    municipio VARCHAR(100)
);

-- Tabla de licencias (hechos)
CREATE TABLE licencias (
    id SERIAL PRIMARY KEY,
    fecha DATE,
    anio INTEGER,
    mes INTEGER,
    cod_dane VARCHAR(5) REFERENCES municipios(cod_dane),
    obj_tra VARCHAR(50),
    clase_suelo VARCHAR(50),
    modalidad VARCHAR(50),
    destino VARCHAR(50),
    tipo_vivi VARCHAR(50),
    vis_novis VARCHAR(50),
    estrato VARCHAR(50),
    area NUMERIC,
    unidades INTEGER,
    licencias INTEGER
);

-- ==============================================================================
-- PROYECTO: Analítica de Licencias de Construcción (ELIC - DANE)
-- KPI 1: Resumen de Actividad Constructora por Departamento (2019 - 2026)
-- ==============================================================================
CREATE OR REPLACE VIEW vista_kpi_area_departamento AS
SELECT 
    m.departamento,
    SUM(l.area) AS area_total_m2,
    SUM(l.unidades) AS unidades_total,
    SUM(l.licencias) AS licencias_total
FROM licencias l
INNER JOIN municipios m ON l.cod_dane = m.cod_dane
GROUP BY m.departamento
ORDER BY area_total_m2 DESC;

-- Consulta de verificación para controlar los 
SELECT * FROM vista_kpi_area_departamento LIMIT 10;

-- ==============================================================================
-- PROYECTO: Analítica de Licencias de Construcción (ELIC - DANE)
-- KPI 2: Ranking de Municipios con Mayor Área Licenciada (2019 - 2026)
-- ==============================================================================
CREATE OR REPLACE VIEW vista_kpi_ranking_municipios AS
SELECT 
    m.municipio,
    m.departamento,
    m.cod_dane,
    SUM(l.area) AS area_total_m2,
    SUM(l.unidades) AS unidades_total,
    SUM(l.licencias) AS licencias_total
FROM licencias l
INNER JOIN municipios m ON l.cod_dane = m.cod_dane
GROUP BY m.municipio, m.departamento, m.cod_dane
ORDER BY area_total_m2 DESC;

-- Consulta rápida para validar el Top 10 de municipios directamente en Postgres
SELECT * FROM vista_kpi_ranking_municipios LIMIT 10;

-- ==============================================================================
-- PROYECTO: Analítica de Licencias de Construcción (ELIC - DANE)
-- KPI 3: Distribución de Vivienda VIS, No VIS y VIP por Departamento (2019 - 2026)
-- ==============================================================================
CREATE OR REPLACE VIEW vista_kpi_distribucion_vivienda AS
SELECT 
    m.departamento,
    l.vis_novis,
    SUM(l.area) AS area_total_m2,
    SUM(l.unidades) AS unidades_total
FROM licencias l
INNER JOIN municipios m ON l.cod_dane = m.cod_dane
WHERE l.vis_novis != 'No aplica' -- Excluimos destinos no residenciales (bodegas, comercio, etc.)
GROUP BY m.departamento, l.vis_novis
ORDER BY m.departamento, area_total_m2 DESC;

-- Consulta rápida para validar la estructura del KPI 3
SELECT * FROM vista_kpi_distribucion_vivienda LIMIT 12;

-- ==============================================================================
-- PROYECTO: Analítica de Licencias de Construcción (ELIC - DANE)
-- KPI 4: Composición Porcentual del Área Licenciada por Destino (Nacional)
-- ==============================================================================

CREATE OR REPLACE VIEW vista_kpi_composicion_destino AS
SELECT 
    l.destino,
    SUM(l.area) AS area_total_m2,
    SUM(l.licencias) AS licencias_total,
    -- Suma el área del destino actual, la divide por el total de la ventana global y calcula el %
    ROUND((SUM(l.area) * 100.0) / SUM(SUM(l.area)) OVER (), 2) AS porcentaje_area
FROM licencias l
GROUP BY l.destino
ORDER BY area_total_m2 DESC;

-- Consulta rápida para ver la radiografía nacional
SELECT * FROM vista_kpi_composicion_destino;

-- ==============================================================================
-- PROYECTO: Analítica de Licencias de Construcción (ELIC - DANE)
-- KPI 5: Composición Porcentual del Área Licenciada por Destino EN CADA DEPARTAMENTO
-- ==============================================================================

CREATE OR REPLACE VIEW vista_kpi_composicion_destino_departamento AS
SELECT 
    m.departamento,
    l.destino,
    SUM(l.area) AS area_total_m2,
    SUM(l.licencias) AS licencias_total,
    ROUND((SUM(l.area) * 100.0) / SUM(SUM(l.area)) OVER (PARTITION BY m.departamento), 2) AS porcentaje_area_depto
FROM licencias l
INNER JOIN municipios m ON l.cod_dane = m.cod_dane
GROUP BY m.departamento, l.destino
ORDER BY m.departamento ASC, area_total_m2 DESC;

-- Consulta de verificación para ver la matriz regional
SELECT * FROM vista_kpi_composicion_destino_departamento LIMIT 200;

