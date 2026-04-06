  --- INSERE OS REGISTROS NA TABELA EV_TICKETS_ZENDESK OFICIAL DA ENG DE VALOR -------
      insert into ev_tickets_zendesk
	  select 
		ticket_id,              assignee_name,          			  brand_name,                		date_created,              				 date_first_assigned, 
		date_last_assigned,     date_last_comment,      			  date_requester_update,     		 date_solved,               			 date_status_updated,
		date_updated,           description,            			  group_name,                		 number_changes_assignee,  			     organization_name, 
		requester_name,         submitter_name,         			  ticket_priority,           		 ticket_form_name,          			 ticket_status, 
		ticket_subject,         type,                   		      aging_backlog,             		 fundido,                   			 group_id, 
		first_sla_date,         ev_catalogo_level1,     			  ev_catalogo_level2,        		 ev_catalogo_level3,        			 ev_catalogo_level4,
		ev_participantes,       ev_gsn,                 			  ev_modelo_atendimento,     		 ev_linha_erp,             				 ev_data_estimada_fechamento, 
		ev_unidade_venda,       ev_codigo_cliente,      			  ev_razao_social_cliente,   		 ev_cidade_cliente,        			     ev_segmento,
		ev_cnae_cliente,        ev_prospect_base,       			  ev_cnpj,                   		 ev_tipo_atendimento,       			 ev_necessario_outros_times, 
		ev_sugestao_produtos,   ev_total_colaboradores, 			  ev_primeira_visita,       		 ev_reversao_churn,         			 ev_novo_licenciamento, 
		ev_contato_esn,        
		COALESCE(CAST(NULLIF(ev_zopa_valor_ideal_nr_comprador, '') AS DECIMAL(15,2)), 0.00), 
		COALESCE(CAST(NULLIF(ev_zopa_valor_aceitavel_vendedor, '') AS DECIMAL(15,2)), 0.00),  
		COALESCE(CAST(NULLIF(ev_zopa_valor_ideal_servico_comprador, '') AS DECIMAL(15,2)), 0.00), 
		COALESCE(CAST(NULLIF(ev_faturamento_bruto, '') AS DECIMAL(15,2)), 0.00), 
		ev_prazo_atendimento,   ev_gpp, ev_concorrente,               ev_linha_produto, 		         ev_servicos_operacao, 					 ev_inovacao, 
		ev_produtos_oferecidos, ev_motivo_perda, ev_modelo_atuacao,   ev_coordenador_atendimento,        ev_prazo_entrega_rfiq,                  ev_status_oportunidade,
		ev_status_forecast,     ev_e_oferta,                          ev_oferta_oferecida,               ev_numero_oportunidade,
		COALESCE(CAST(NULLIF(ev_valor_servicos, '') AS DECIMAL(15,2)), 0.00),
		ev_projeto_saastizado, 
		COALESCE(CAST(NULLIF(ev_valor_recorrente, '') AS DECIMAL(15,2)), 0.00), 
		COALESCE(CAST(NULLIF(ev_valor_cdu, '') AS DECIMAL(15,2)), 0.00)
		from zendesk_tickets_transitoria