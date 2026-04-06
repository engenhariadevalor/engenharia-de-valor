#%%
import urllib.parse
from datetime import datetime

# --- Autor: Julio Cesar Guerato / Março-2026 ---

# --- Data e Hora de Inicio da execução ---
data_inicio = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# --- Linha comentada somente para ver se entrou na rotina ---
#print(f"Execução iniciada em: {data_inicio}")
#input("\nPressione [ENTER] para continuar com o script...")

# --- Conexão com a CAROL ---
from pycarol import ApiKeyAuth, Carol, BQ

DOMAIN       = "evbr"
APP_NAME     = "schedullezendesk"
CONNECTORID  = "a322442ebe7645cab69874c75fdaec6f"
ORGANIZATION = "totvs"
X_AUTH_KEY   = "51f56477213d4aa49e570e2520a8e06b"

carol = Carol(
    domain=DOMAIN,
    app_name=APP_NAME,
    auth=ApiKeyAuth(api_key=X_AUTH_KEY),
    connector_id=CONNECTORID,
    organization=ORGANIZATION
)

# --- Query para buscar os Clientes na tabela  ---
SQL = """SELECT codt,              razao_social,         cnpj,      tipo_cliente,    status_cliente,   uf,             municipio,            segmento,          codigo_unidade,
                nome_unidade,      codigo_esn,           nome_esn,   nome_gsn,        nome_dsn,        
                max(perc_predicao_de_churn) as perc_predicao_de_churn,    
                max(faturamento) as faturamento,
                max(mrr_contratado_real) as mrr_contratado_real,
                max(mrr_pagante_real) as mrr_pagante_real
           FROM `carol-b6f9107597e5491c9aa2.shd_totvs_estrategiacomercial_engenhariavalor.CLIENTES_ATIVOS`
           group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
"""

# --- Armazena o retorno da Query executada na BigQuery ---
RetornoQuery = BQ(carol).query(SQL)  

#--- Printa o conteúdo ---
#RetornoQuery.head() 
#print(RetornoQuery.head())

# --- CONFIGURAÇÕES DO SEU MYSQL ---
from sqlalchemy import create_engine
import urllib.parse  

USER                = 'evuserdatalake'
PASSWORD            = 'TotvsEvDataLake2026@!'
HOST                = '137.131.154.156'
DATABASE            = 'totvs_ev_datalake'
PORT                = '3306'
TABELA_DESTINO      = 'ev_clientes'


import mysql.connector
mysql_config = {
    'host': '137.131.154.156',
    'port': 3306,
    'user': 'evuserdatalake',
    'password': 'TotvsEvDataLake2026@!',
    'database': 'totvs_ev_datalake'
}

# --- Trata senha com Caracteres especiais ----
safe_password = urllib.parse.quote_plus(PASSWORD)   

# --- Criar a string de conexão -----
engine = create_engine(f"mysql+mysqlconnector://{USER}:{safe_password}@{HOST}:{PORT}/{DATABASE}")

try:
    # --- Inserir o DataFrame no MySQL o retorno da Query / ficará na tabela ev_clientes ---
    RetornoQuery.to_sql(TABELA_DESTINO, con=engine, if_exists='replace', index=False)
    qtd_registros = len(RetornoQuery)

    print("Clientes ativos")

    # --- Data e Hora de término do Big Query ----
    data_fim = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    print(f"Sucesso! {len(RetornoQuery)} registros inseridos na tabela {TABELA_DESTINO}.")
    engine.dispose()

    # ---- Grava o Log de processamento --- #
    conn = mysql.connector.connect(**mysql_config)
    if conn.is_connected():
        # print("Conexão com MySQL estabelecida com sucesso!")
        cursor = conn.cursor()
        
        ##SQL = "Delete From zendesk_processamento_work where 1=1"
        ##cursor.execute(SQL)
   
        ##SQL = f"INSERT INTO zendesk_processamento_work (data_proc_bigquery, data_term_bigquery, qtd_registros_bigquery) VALUES ('{data_inicio}', '{data_fim}', {qtd_registros})"
        cursor.execute(SQL)
        
        conn.commit()
  
except Exception as e:
    print(f"Erro ao inserir no MySQL: {e}")

finally:
    engine.dispose()