## Airport Data - Data Engineering Challenge

### Requisitos

Esse projeto foi feito utilizando Jupyter e requer Python 3 e as bibliotecas a seguir:

Para instalar essas libraries : 

```pip install -r requirements.txt ```

É feito o uso do seguinte [Conjunto de dados 1](https://github.com/samuel2pb/Airports---Data-Engineering/tree/main/AIR_CIA)
[Conjunto de dados 2](https://github.com/samuel2pb/Airports---Data-Engineering/tree/main/VRA)
[API](https://rapidapi.com/Active-api/api/airport-info/)


### Apresentação

Para uma Ingestão incremental dos dados, pode ser utilizado uma solução baseada em ferramentas CDC (Change Data Capture). 
Essa solução funciona da seguinte forma, a ferramenta captura o Delta (Incremento) dos bancos transacionais e guarda esses registros compactados numa camada RAW numa cloud.
A partir disso, os dados podem ser ingeridos uma vez por mês com o batch (lote de incrementos) acumulado até o momento, isso orquestrado via Airflow.
Uma vez os dados na camada SSOT (Fonte da verdade), estes podem ser utilizados para atualizar a versão da visão.

As tecnologias chave deste processo são um bucket numa Cloud Pública, um CDC, um Data Warehouse, Airflow e Spark. Veja que citei os primeiros três de forma genérica pois podem ser implementados utilizando diversas ferramentas. As justificativas para o uso do CDC é sua praticidade e custo benefício, onde 100GB de transferência incremental mensais custariam aproximadamente 150USD, isso significa também que para as necessidades de escalabilidade funcionaria muito bem com rotinas mais frequentes do Airflow e Spark, tendo inclusiva capacidade de fornecimento de dados em tempo real. 

As camadas utilizadas dentro dessa solução são uma camada RAW (Bucket) , com apenas dados incrementais comprimidos. Uma camada SSOT (Data Warehouse) Single Source Of Truth, fonte de verdade com dados normalizados e deduplicados. E uma camada de Consumo (Data Warehouse), baseado em visões prontas e otimizadas para a colsulta de usuários de negócio.

Uma Camada Raw é importante para uma enventual necessidade de reprocessamento de dados, nela também é possível perceber falhas vindas do banco transacional. 

Uma Camada SSOT é essencial para a modelagem de Visões e ela serve como um histórico tratado da camada RAW. 

Uma Camada de Consumo é a base de toda estretégia de Bussiness Inteligence passivel de ser implementada.


Um exemplo dessa arquitetura baseado nos serviços do Google Cloud Platform pode ser visto no seguinte [Diagrama](https://drive.google.com/file/d/1FWkU64tA0vQQLzIiY_z8qB-MGSSyxbSa/view?usp=sharing).

<img src="https://github.com/samuel2pb/Airports---Data-Engineering/blob/main/Airport%20Data%20Architecture.drawio.png" alt="MarineGEO circle logo" style="height: 1000px; width:1500px;"/>


