#%%
import urllib.parse
from datetime import datetime

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

# --- Query para buscar os Tickets na tenant Zendesk ---
# --- Tabelas: zendesk_gold_tickets e zendesk_gold_customfields ---

SQL = """SELECT a.ticket_id,  a.assignee_name,           a.brand_name,              a.date_created, 
       a.date_first_assigned, a.date_last_assigned,      a.date_last_comment,       a.date_requester_update,
       a.date_solved,         a.date_status_updated,     a.date_updated,            a.description, 
       a.group_name,          a.number_changes_assignee, a.organization_name,       a.requester_name,
       a.submitter_name,      a.ticket_priority,         a.ticket_form_name,        a.ticket_status,
       a.ticket_subject,      a.type,                    a.aging_backlog,           a.fundido,    
       a.group_id,            a.first_sla_date,          a.follower_ids,  
                     
       MAX(CASE WHEN b.field_id = 43609617432083 then value END) as ev_issue_jira,

       MAX(CASE WHEN b.field_id = 43752318044563 then value END) as ev_catalogo_level1,
       MAX(CASE WHEN b.field_id = 43752308882963 then value END) as ev_catalogo_level2,
       MAX(CASE WHEN b.field_id = 43272089249299 then value END) as ev_catalogo_level3,
       MAX(CASE WHEN b.field_id = 43272061380115 then value END) as ev_catalogo_level4,
              
       MAX(CASE WHEN b.field_id = 43287434732051 then value END) as ev_participantes,
       MAX(CASE WHEN b.field_id = 46018623433363 then value END) as ev_gsn,
       MAX(CASE WHEN b.field_id = 45110902548627 then value END) as ev_modelo_atendimento,
           
       MAX(CASE WHEN b.field_id = 45110575185427 then value END) as ev_linha_erp,
       MAX(CASE WHEN b.field_id = 44011524949139 then value END) as ev_data_estimada_fechamento,
       MAX(CASE WHEN b.field_id = 43345519142035 then value END) as ev_unidade_venda,

       MAX(CASE WHEN b.field_id = 43345156008083 then value END) as ev_codigo_cliente,
       MAX(CASE WHEN b.field_id = 43345094638995 then value END) as ev_razao_social_cliente,
       MAX(CASE WHEN b.field_id = 43345200781971 then value END) as ev_cidade_cliente,
       MAX(CASE WHEN b.field_id = 43288165891475 then value END) as ev_segmento,
       MAX(CASE WHEN b.field_id = 43345213211283 then value END) as ev_cnae_cliente,
       MAX(CASE WHEN b.field_id = 45110365937427 then value END) as ev_prospect_base,
       MAX(CASE WHEN b.field_id = 44332035192595 then value END) as ev_cnpj,

       MAX(CASE WHEN b.field_id = 49006269751571 then value END) as ev_cargo_do_cliente,
       MAX(CASE WHEN b.field_id = 48811290713619 then value END) as ev_celular_do_cliente,
       MAX(CASE WHEN b.field_id = 49006329704339 then value END) as ev_email_do_cliente,
       MAX(CASE WHEN b.field_id = 49006224406163 then value END) as ev_site_do_cliente,
       MAX(CASE WHEN b.field_id = 43287812707347 then value END) as ev_cargo_do_solicitante,
       MAX(CASE WHEN b.field_id = 45110270766995 then value END) as ev_area_do_solicitante,

       MAX(CASE WHEN b.field_id = 43286863910803 then value END) as ev_data_material_pronto,
       MAX(CASE WHEN b.field_id = 45110337449491 then value END) as ev_publico_material,
       MAX(CASE WHEN b.field_id = 43287122775443 then value END) as ev_externo_link_material,
       MAX(CASE WHEN b.field_id = 43093605011347 then value END) as ev_projeto_relacao_oferta,


       MAX(CASE WHEN b.field_id = 43286963535507 then value END) as ev_equipe_envolvida,
       MAX(CASE WHEN b.field_id = 45126914629267 then value END) as ev_squad,
       MAX(CASE WHEN b.field_id = 45908312458387 then value END) as ev_equipe_triagem,
       MAX(CASE WHEN b.field_id = 45908351036563 then value END) as ev_status_triagem,

       
       MAX(CASE WHEN b.field_id = 43093105543571 then value END) as ev_tipo_atendimento,
       MAX(CASE WHEN b.field_id = 45110745672851 then value END) as ev_necessario_outros_times,
       MAX(CASE WHEN b.field_id = 44011370955539 then value END) as ev_sugestao_produtos,
       MAX(CASE WHEN b.field_id = 43345059451667 then value END) as ev_total_colaboradores,
       MAX(CASE WHEN b.field_id = 45110609533075 then value END) as ev_primeira_visita,
       
       MAX(CASE WHEN b.field_id = 43288061840659 then value END) as ev_reversao_churn,
       MAX(CASE WHEN b.field_id = 44011692497427 then value END) as ev_novo_licenciamento,
       MAX(CASE WHEN b.field_id = 44011498208531 then value END) as ev_contato_esn,
     
       MAX(CASE WHEN b.field_id = 44011409836435 then value END) as ev_zopa_valor_ideal_nr_comprador,
       MAX(CASE WHEN b.field_id = 44011406646547 then value END) as ev_zopa_valor_aceitavel_vendedor,
       MAX(CASE WHEN b.field_id = 44011433771411 then value END) as ev_zopa_valor_ideal_servico_comprador,
       MAX(CASE WHEN b.field_id = 43345085104019 then value END) as ev_faturamento_bruto,
       MAX(CASE WHEN b.field_id = 43287541991699 then value END) as ev_prazo_atendimento,
       MAX(CASE WHEN b.field_id = 43286984120979 then value END) as ev_gpp,
       MAX(CASE WHEN b.field_id = 43345614380051 then value END) as ev_concorrente,
       MAX(CASE WHEN b.field_id = 43287077464339 then value END) as ev_linha_produto,
       MAX(CASE WHEN b.field_id = 43288168999699 then value END) as ev_servicos_operacao,
       MAX(CASE WHEN b.field_id = 43287047438227 then value END) as ev_inovacao,
       MAX(CASE WHEN b.field_id = 44131561697939 then value END) as ev_produtos_oferecidos,
       MAX(CASE WHEN b.field_id = 43287206814099 then value END) as ev_motivo_perda,
       MAX(CASE WHEN b.field_id = 43287137550227 then value END) as ev_modelo_atuacao,
       MAX(CASE WHEN b.field_id = 43286735355155 then value END) as ev_coordenador_atendimento,
       MAX(CASE WHEN b.field_id = 44011353854227 then value END) as ev_prazo_entrega_rfiq,

       MAX(CASE WHEN b.field_id = 43288220694675 then value END) as ev_status_oportunidade,
       MAX(CASE WHEN b.field_id = 43288294653203 then value END) as ev_status_forecast,
       MAX(CASE WHEN b.field_id = 45110677502611 then value END) as ev_e_oferta,
       MAX(CASE WHEN b.field_id = 43287379083155 then value END) as ev_oferta_oferecida,
       MAX(CASE WHEN b.field_id = 44011455676819 then value END) as ev_numero_oportunidade,

       MAX(CASE WHEN b.field_id = 47099181265939 then value END) as ev_valor_servicos,
       MAX(CASE WHEN b.field_id = 43287573447571 then value END) as ev_projeto_saastizado,
       MAX(CASE WHEN b.field_id = 47099212498195 then value END) as ev_valor_recorrente,
       MAX(CASE WHEN b.field_id = 47099008373267 then value END) as ev_valor_cdu,
       MAX(CASE WHEN b.field_id = 47099218753555 then value END) as ev_valor_proposta,
       0 as ev_ajuste_level
     
FROM `carol-b6f9107597e5491c9aa2.shd_totvs_engenhariacorporativa_basededadosdozendesk.zendesk_gold_tickets` a
left join'
`carol-b6f9107597e5491c9aa2.shd_totvs_engenhariacorporativa_basededadosdozendesk.zendesk_gold_tickets_customfields` b
on a.ticket_id = b.ticket_id
Where a.group_name = 'Engenharia de Valor TOTVS' 
  and a.new_api    = true
Group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27
"""

# ---  Query para busca de usuário do zendesk - Tabela Users ---
SQL_USER = """SELECT id, email 
                From `carol-b6f9107597e5491c9aa2.shd_totvs_engenhariacorporativa_usuarioszendesk.users`
               Where email like '%@totvs.com.br' 
                 and new_api = true
"""

# --- Armazena o retorno da Query executada na BigQuery ---
RetornoQuery = BQ(carol).query(SQL)  
RetornoQuery_User = BQ(carol).query(SQL_USER)  

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
TABELA_DESTINO      = 'zendesk_tickets_tenant'
TABELA_DESTINO_USER = 'ev_users_zendesk'


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
    # --- Inserir o DataFrame no MySQL o retorno da Query / ficará na tabela Zendesk_tickets_tenant ---
    RetornoQuery.to_sql(TABELA_DESTINO, con=engine, if_exists='replace', index=False)
    qtd_registros = len(RetornoQuery)

    print("Zendesk")

    # --- Inserir o DataFrame no MySQL o retorno da Query / ficará na tabela ev_user_zendesk ---
    RetornoQuery_User.to_sql(TABELA_DESTINO_USER, con=engine, if_exists='replace', index=False)
    qtd_registros_user = len(RetornoQuery_User)

    print("Usuario")

    # --- Data e Hora de término do Big Query ----
    data_fim = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    print(f"Sucesso! {len(RetornoQuery)} registros inseridos na tabela {TABELA_DESTINO}.")
    engine.dispose()

    # ---- Grava o Log de processamento --- #
    conn = mysql.connector.connect(**mysql_config)
    if conn.is_connected():
        # print("Conexão com MySQL estabelecida com sucesso!")
        cursor = conn.cursor()
        
        SQL = "Delete From zendesk_processamento_work where 1=1"
        cursor.execute(SQL)
   
        SQL = f"INSERT INTO zendesk_processamento_work (data_proc_bigquery, data_term_bigquery, qtd_registros_bigquery) VALUES ('{data_inicio}', '{data_fim}', {qtd_registros})"
        cursor.execute(SQL)
        
        conn.commit()
  
except Exception as e:
    print(f"Erro ao inserir no MySQL: {e}")

finally:
    engine.dispose()