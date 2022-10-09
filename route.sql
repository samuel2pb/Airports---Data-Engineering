 /*Para cada companhia aérea trazer a rota mais utilizada com as seguintes informações:
 Razão social da companhia aérea
 Nome Aeroporto de Origem
 ICAO do aeroporto de origem
 Estado/UF do aeroporto de origem
 Nome do Aeroporto de Destino
 ICAO do Aeroporto de destino
 Estado/UF do aeroporto de destino  */

WITH rotas_populares AS (
SELECT
  icao_empresa_aerea,
  icao_aerodromo_origem,
  icao_aerodromo_destino,
  COUNT(*) AS voos
  
FROM vra
GROUP BY 1,2,3
),

ranking AS (
  SELECT 
  icao_empresa_aerea,
  MAX(voos) max_voos

  FROM rotas_populares
  GROUP BY 1
),

razao_social AS (
SELECT DISTINCT
  rp.icao_empresa_aerea,
  cia.razao_social,
  rp.icao_aerodromo_origem,
  rp.icao_aerodromo_destino,
  rk.max_voos 
FROM ranking rk
LEFT JOIN rotas_populares rp ON rk.icao_empresa_aerea = rp.icao_empresa_aerea AND rp.voos = rk.max_voos
LEFT JOIN air_cia cia ON cia.icao = rp.icao_empresa_aerea
WHERE cia.icao IS NOT NULL
),

origem AS (

SELECT 
rs.*,
air.name aeroporto_origem,
air.state estado_origem

FROM razao_social rs
LEFT JOIN aerodromos air ON rs.icao_aerodromo_origem = air.icao
),

final as (

SELECT 
ori.razao_social,
ori.aeroporto_origem,
ori.icao_aerodromo_origem,
ori.estado_origem,
air.name aeroporto_destino,
ori.icao_aerodromo_destino,
air.state estado_destino

FROM origem ori 
LEFT JOIN aerodromos air ON ori.icao_aerodromo_destino = air.icao
)


SELECT * FROM final

