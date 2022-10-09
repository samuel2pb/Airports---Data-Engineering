 /*  - Para cada aeroporto trazer a companhia aérea com maior atuação no ano com as seguintes informações:
    - Nome do Aeroporto
    - ICAO do Aeroporto
    - Razão social da Companhia Aérea
    - Quantidade de Rotas à partir daquele aeroporto
    - Quantidade de Rotas com destino àquele aeroporto
    - Quantidade total de pousos e decolagens naquele aeroporto*/

WITH origem  AS (
SELECT
    icao_empresa_aerea,
    icao_aerodromo_origem,
    COUNT(icao_aerodromo_origem) decolagens,
    COUNT(DISTINCT icao_aerodromo_destino ) n_destinos
FROM vra
GROUP BY 1,2
),

destino AS (
SELECT
    icao_empresa_aerea,
    icao_aerodromo_destino,
    COUNT(icao_aerodromo_destino) pousos,
    COUNT(DISTINCT icao_aerodromo_origem) n_origens
FROM vra
GROUP BY 1,2
),

step AS (
SELECT
    a.icao,
    icao_empresa_aerea,
    MAX(o.decolagens) decolagens,
    o.n_destinos

FROM aerodromos a
JOIN origem o ON icao = icao_aerodromo_origem
GROUP BY 1
),

metricas AS (
    SELECT
    icao,
    s.icao_empresa_aerea,
    s.n_destinos,
    d.n_origens,
    MAX(decolagens) + MAX(pousos) total_voos

    FROM step s
    JOIN destino d ON s.icao = d.icao_aerodromo_destino AND d.icao_empresa_aerea = s.icao_empresa_aerea
    GROUP BY 1
),

final AS (
    SELECT
    a.name nome_aeroporto,
    m.icao icao_aeroporto,
    cia.razao_social cia_area,
    m.n_destinos,
    m.n_origens,
    m.total_voos

    FROM aerodromos a
    JOIN metricas m ON a.icao = m.icao
    join air_cia cia ON cia.icao = m.icao_empresa_aerea
)

SELECT * FROM final
ORDER BY total_voos DESC
