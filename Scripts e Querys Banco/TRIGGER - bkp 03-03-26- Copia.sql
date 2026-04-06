DELIMITER //
CREATE TRIGGER trigger_zendesk_tickets_transitoria
AFTER INSERT ON zendesk_processamento_work
FOR EACH ROW
BEGIN

    -- Variável para guardar registros
    DECLARE total_registros INT;

    -- Quantidade de registros da tabela
    SELECT COUNT(*) INTO total_registros FROM zendesk_processamento_work;

    -- Insere tickets capturados do zendesk em tabela de trabalho
    INSERT INTO zendesk_tickets_transitoria
    select * from zendesk_tickets_tenant;
    
    -- Atualiza campos da tabela de trabalho em função da forma como o Zendesk envia ---
    
    -- Modelo de atendimento --
    UPDATE zendesk_tickets_transitoria
    SET ev_modelo_atendimento = CASE 
        WHEN trim(ev_modelo_atendimento)      = 'Modelo Remoto'                                      THEN 'Remoto'
        WHEN trim(ev_modelo_atendimento)      = 'qual_sera_o_modelo_de_atendimento_ambos'        	 THEN 'Ambos'
        WHEN trim(ev_modelo_atendimento)      = 'qual_sera_o_modelo_de_atendimento_presencial'       THEN 'Presencial'
		WHEN trim(ev_modelo_atendimento) is null  THEN '-'
        ELSE ev_modelo_atendimento
     END;
     
    -- força a parada SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A trigger disparou com sucesso!';

    -- Tipo de atendimento --
    UPDATE zendesk_tickets_transitoria
    SET ev_tipo_atendimento = CASE 
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Atendimento de Oportunidades para Clientes e Prospects_Anállise de Oportunidades e geração de valor para clientes e Prospects'                 THEN 'Análise de Oportunidades e Geração de Valor para Clientes e Prospects'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Atendimento de Oportunidades para Clientes e Prospects_Demonstração para Clientes e Prospects'                                                 THEN 'Atendimento de Oportunidades para Clientes e Prospects - Demonstração para Clientes e Prospects'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Atendimento de Oportunidades para Clientes e Prospects_Solicitação de Projeto com HUB de Soluções (Value Assessment) - Clientes e Prospects'   THEN 'Solicitação de Projeto com Hub de Soluções (Value Assessment) - Clientes e Prospects'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Atendimento de Oportunidades para Clientes e Prospects_Solicitação de Proposta Padrões (Fast Track)'                                           THEN 'Solicitação de Proposta Padrões (Fast Track)'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Atendimento de Oportunidades para Clientes e Prospects_Solicitação Imersão 360º'															     THEN 'Solicitação Imersão 360'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Atendimento de Oportunidades para Clientes e Prospects_Solução de RFI/RFP para clientes e Prospects'                                        	 THEN 'Solicitação de RFI / RFP para Clientes e Prospects'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Atendimento de Oportunidades para Clientes e Prospects_TOTVS Day - Clientes e Prospects'                                                    	 THEN 'Totvs Day - Clientes e Prospects'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Design de negócios: Demanda cliente TOTVS_Apoio Estratégico em Oportunidade'																	 THEN 'Demanda Cliente TOTVS - Apoio Estratégico em Oportunidades'
	    WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Design de negócios: Demanda cliente TOTVS_Assessorias'																						 THEN 'Demanda Cliente TOTVS - Assessorias'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Design de negócios: Demanda interna TOTVS_Apoio a Eventos' 																					 THEN 'Demanda Interna TOTVS - Apoio a Eventos'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Design de negócios: Demanda interna TOTVS_Assessoria estratégica'                                                                            	 THEN 'Demanda Interna TOTVS - Assessoria Estratégica'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Design de negócios: Demanda interna TOTVS_Estratégia Go To Market (GTM)'																		 THEN 'Demanda Interna TOTVS - Estratégia GO TO MARKET (GTM)'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Design de negócios: Demanda interna TOTVS_Estratégias e Planejamentos'                                                                         THEN 'Demanda Interna TOTVS - Estratégias e Planejamentos'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Design de negócios: Demanda interna TOTVS_Kit de Vendas'																						 THEN 'Demanda Interna TOTVS - Kit de Vendas'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Setor Público - SPUB_Análise de Edital para Clientes e Prospects' 																			 THEN 'Setor Publico - Análise de Edital para Clientes e Prospects'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_Engenharia de Valor TOTVS_Setor Público - SPUB_Análise de TR para Clientes e Prospects'																					 THEN 'Setor Publico - Análise de TR para Clientes e Prospects'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_RD Station_Arquitetura' 																																				 THEN 'RD Station - Arquitetura'
        WHEN trim(ev_tipo_atendimento) = 'Engenharia de Valor TOTVS_RD Station_Demonstração_RD Conversas' 																																     THEN 'RD Station - Demonstração RD Conversas'
		WHEN trim(ev_tipo_atendimento) is null  THEN '-'
        ELSE ev_tipo_atendimento
     END;
     
	 -- Linha ERP`--
     UPDATE zendesk_tickets_transitoria
		SET ev_linha_erp = CASE
        WHEN trim(ev_linha_erp) = 'linha_de_erpadp'                                                       THEN 'ADP'
		WHEN trim(ev_linha_erp) = 'linha_de_erpcisspoder'												  THEN 'Cis Spoder'
		WHEN trim(ev_linha_erp) = 'linha_de_erpconsinco'											      THEN 'TOTVS - Consinco'
		WHEN trim(ev_linha_erp) = 'linha_de_erpgupy'												      THEN 'Gupy'
		WHEN trim(ev_linha_erp) = 'linha_de_erpinfor' 													  THEN 'Infor'
		WHEN trim(ev_linha_erp) = 'linha_de_erplg' 														  THEN 'LG'
		WHEN trim(ev_linha_erp) = 'linha_de_erpnimbi' 													  THEN 'Nimbi'
		WHEN trim(ev_linha_erp) = 'linha_de_erpomie'  													  THEN 'Omie'
		WHEN trim(ev_linha_erp) = 'linha_de_erporacle'   												  THEN 'Oracle'
		WHEN trim(ev_linha_erp) = 'linha_de_erporacle_netsuite'  					                      THEN 'NetSuite'					
		WHEN trim(ev_linha_erp) = 'linha_de_erpproprietário'   											  THEN 'Proprietário'
		WHEN trim(ev_linha_erp) = 'linha_de_erpsankhya'  												  THEN 'Sankhya'
		WHEN trim(ev_linha_erp) = 'linha_de_erpsap_b1'          		                                  THEN 'SAP B1'
		WHEN trim(ev_linha_erp) = 'linha_de_erpsap_hana' 				  					    	      THEN 'SAP Hana'
		WHEN trim(ev_linha_erp) = 'linha_de_erpsenior'  												  THEN 'Senior'
		WHEN trim(ev_linha_erp) = 'linha_de_erpshop_control'  											  THEN 'Shop Control'
		WHEN trim(ev_linha_erp) = 'linha_de_erpshopify'                                                   THEN 'Shopify'
		WHEN trim(ev_linha_erp) = 'linha_de_erpsolidcon'  												  THEN 'Solidcon'
		WHEN trim(ev_linha_erp) = 'linha_de_erptarget'   												  THEN 'Target'
		WHEN trim(ev_linha_erp) = 'linha_de_erptotvs_plataforma_linha_datasul' 							  THEN 'TOTVS - Datasul'
		WHEN trim(ev_linha_erp) = 'linha_de_erptotvs_plataforma_linha_logix' 							  THEN 'TOTVS - Logix'
		WHEN trim(ev_linha_erp) = 'linha_de_erptotvs_plataforma_linha_protheus' 			 			  THEN 'TOTVS - Protheus'
		WHEN trim(ev_linha_erp) = 'linha_de_erptotvs_plataforma_linha_rm'                         		  THEN 'TOTVS - RM'
		WHEN trim(ev_linha_erp) = 'linha_de_erptotvs_plataforma_linha_winthor'                  		  THEN 'TOTVS - WINTHOR'
		WHEN trim(ev_linha_erp) = 'linha_de_erptotvs_plataforma_sara'                             		  THEN 'TOTVS - SARA'
		WHEN trim(ev_linha_erp) = 'linha_de_hotelaria_totvs_gestão_back_office_legado'                    THEN 'TOTVS - Gestão Back Office Legado'
		WHEN trim(ev_linha_erp) = 'linha_de_hotelaria_totvs_gestão_back_office_linha_saas'                THEN 'TOTVS - Gestão Back Office Linha SAAS' 
		WHEN trim(ev_linha_erp) = 'linha_de_hotelaria_totvs_gestão_mobiles'                               THEN 'TOTVS - Gestão Mobiles'
	    WHEN trim(ev_linha_erp) = 'linha_de_hotelaria_totvs_gestão_visual_hotal_front_office_legado'      THEN 'TOTVS - Gestão Visual Hotal Front Office Legado'
        WHEN trim(ev_linha_erp) is null    													      		  THEN '-'
		ELSE ev_linha_erp
     END;
     
    -- Unidade de Venda --
    UPDATE zendesk_tickets_transitoria
		SET ev_unidade_venda = CASE 
        WHEN trim(ev_unidade_venda) = 'ev_sp1'      										   THEN 'SP1'
        WHEN trim(ev_unidade_venda) = 'ev_sp2'      										   THEN 'SP2'
        WHEN trim(ev_unidade_venda) = 'ev_sp3'      										   THEN 'SP3'
        WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_corporativo'                  THEN 'Corporativo'
        WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_corporativo'            THEN 'Totvs Corporativo'
		WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_hotelaria'              THEN 'Totvs Hotelaria'
        WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_interior_paulista'      THEN 'Totvs Interior Paulista'
        WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_large_enterprise'       THEN 'Totvs Large Enterprise'
        WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_mexico'                 THEN 'Totvs Mexico'
        WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_minas_gerais'           THEN 'Totvs Minas Gerais'
        WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_rd'                     THEN 'Totvs RD'
        WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_recife'                 THEN 'Totvs Recife'
		WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_rio_de_janeiro'         THEN 'Totvs Rio de Janeiro'
        WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_rio_grande_do_sul'      THEN 'Totvs Rio Grande do Sul'
		WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_sao_paulo'              THEN 'Totvs São Paulo'
	    WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_saude'                  THEN 'Totvs Saude'
        WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_spub'                   THEN 'Totvs Setor Publico'
        WHEN trim(ev_unidade_venda) = 'ev_totvs_unidade_de_venda_totvs_supermercados'          THEN 'Totvs Supermercados'
		WHEN trim(ev_unidade_venda) is null    THEN '-'
        ELSE ev_unidade_venda
     END;
     
	 -- Prospect ou base  --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_prospect_base = CASE 
	    WHEN trim(ev_prospect_base) = 'e_prospect_ou_cliente_base_base'        THEN 'Base'
        WHEN trim(ev_prospect_base) = 'e_prospect_ou_cliente_base_prospect'    THEN 'Prospect'
        WHEN trim(ev_prospect_base) is null    THEN '-'
		ELSE ev_prospect_base
	 END;
     
     -- Segmento --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_segmento = CASE 
	    WHEN trim(ev_segmento) = 'ev_totvs_segmento_agro'         				   THEN 'Agro'
        WHEN trim(ev_segmento) = 'ev_totvs_segmento_construcao'                    THEN 'Construção'
		WHEN trim(ev_segmento) = 'ev_totvs_segmento_distribuicao'                  THEN 'Distribuição'
		WHEN trim(ev_segmento) = 'ev_totvs_segmento_educacional'                   THEN 'Educacional'
		WHEN trim(ev_segmento) = 'ev_totvs_segmento_financial_services'            THEN 'Financial Services'
		WHEN trim(ev_segmento) = 'ev_totvs_segmento_hospitalidade'                 THEN 'Hospitalidade'
		WHEN trim(ev_segmento) = 'ev_totvs_segmento_juridico'                      THEN 'Jurídico'
		WHEN trim(ev_segmento) = 'ev_totvs_segmento_logistica'                     THEN 'Logística'
		WHEN trim(ev_segmento) = 'ev_totvs_segmento_manufatura'                    THEN 'Manufatura'
		WHEN trim(ev_segmento) = 'ev_totvs_segmento_prestadores_de_servicos'       THEN 'Prestadores de Serviços'
		WHEN trim(ev_segmento) = 'ev_totvs_segmento_saude'                         THEN 'Saúde'
		WHEN trim(ev_segmento) = 'ev_totvs_segmento_setor_publico'                 THEN 'Setor Público'
		WHEN trim(ev_segmento) = 'ev_totvs_segmento_varejo'                        THEN 'Varejo'
        WHEN trim(ev_segmento) is null    THEN '-'
		ELSE ev_modelo_atendimento
	 END;
     
     -- Necessário atuação de outros times --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_necessario_outros_times = CASE 
	    WHEN trim(ev_necessario_outros_times) = 'necessario_atuacao_de_outros_times_nao'    THEN 'Não'
        WHEN trim(ev_necessario_outros_times) = 'necessario_atuacao_de_outros_times_sim'    THEN 'Sim'
		WHEN trim(ev_necessario_outros_times) is null    THEN '-'
		ELSE ev_necessario_outros_times
	 END;
     
	 -- Primeira Visita --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_primeira_visita = CASE 
	    WHEN trim(ev_primeira_visita) = 'primeira_visita_nao'    THEN 'Não'
        WHEN trim(ev_primeira_visita) = 'primeira_visita_sim'    THEN 'Sim'
        WHEN trim(ev_primeira_visita) is null    THEN '-'
		ELSE ev_primeira_visita
	 END;
     
	 -- Reversão de Churn --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_reversao_churn = CASE 
	    WHEN trim(ev_reversao_churn) = 'ev_totvs_reversao_de_churn_nao'    THEN 'Não'
        WHEN trim(ev_reversao_churn) = 'ev_totvs_reversao_de_churn_sim'    THEN 'Sim'
        WHEN trim(ev_reversao_churn) is null    THEN '-'
		ELSE ev_reversao_churn
	 END;
     
     -- Status da Oportunidade --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_status_oportunidade = CASE 
		WHEN trim(ev_status_oportunidade) = 'ev_totvs_status_da_oportunidade_rtc_analise_do_ev'            THEN 'Análise do EV'
		WHEN trim(ev_status_oportunidade) = 'ev_totvs_status_da_oportunidade_rtc_apresentacao_executiva'   THEN 'Apresentação executiva'
		WHEN trim(ev_status_oportunidade) = 'ev_totvs_status_da_oportunidade_rtc_aprovacao_gpp' 		   THEN 'Aprovação GPP'
		WHEN trim(ev_status_oportunidade) = 'ev_totvs_status_da_oportunidade_rtc_arquitetura' 			   THEN 'Arquitetura'
		WHEN trim(ev_status_oportunidade) = 'ev_totvs_status_da_oportunidade_rtc_com_parceiro'             THEN 'Com Parceiro'
		WHEN trim(ev_status_oportunidade) = 'ev_totvs_status_da_oportunidade_rtc_demo'                     THEN 'Demonstração'
		WHEN trim(ev_status_oportunidade) = 'ev_totvs_status_da_oportunidade_rtc_em_negociacao'            THEN 'Em negociação'
		WHEN trim(ev_status_oportunidade) = 'ev_totvs_status_da_oportunidade_rtc_levantamento'             THEN 'Levantamento'
		WHEN trim(ev_status_oportunidade) is null    THEN '-'
		ELSE ev_status_oportunidade
	 END;
     
     -- Status ForeCast --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_status_forecast = CASE 
		WHEN trim(ev_status_forecast) = 'ev_totvs_status_forecast_committed'      THEN 'Committed'
		WHEN trim(ev_status_forecast) = 'ev_totvs_status_forecast_lead'           THEN 'Lead'  
		WHEN trim(ev_status_forecast) = 'ev_totvs_status_forecast_lost'           THEN 'Lost'
		WHEN trim(ev_status_forecast) = 'ev_totvs_status_forecast_probable'       THEN 'Probable'
		WHEN trim(ev_status_forecast) = 'ev_totvs_status_forecast_upside'         THEN 'Upside'
		WHEN trim(ev_status_forecast) = 'ev_totvs_status_forecast_won'            THEN 'Won'
        WHEN trim(ev_status_forecast) is null    THEN '-'
		ELSE ev_status_forecast
	 END;
     
     -- É oferta ? --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_e_oferta = CASE 
	    WHEN trim(ev_e_oferta) = 'e_um_oferta_nao'    THEN 'Não'
        WHEN trim(ev_e_oferta) = 'e_um_oferta_sim'    THEN 'Sim'
        WHEN trim(ev_e_oferta) is null    THEN '-'
        ELSE ev_e_oferta 
	 END;
     
      -- Projeto Saastizado ? --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_projeto_saastizado = CASE
	    WHEN trim(ev_projeto_saastizado) = 'ev_totvs_projeto_saastizado_nao'    THEN 'Não'
        WHEN trim(ev_projeto_saastizado) = 'ev_totvs_projeto_saastizado_sim'    THEN 'Sim'
        WHEN trim(ev_projeto_saastizado) is null    THEN '-'
        ELSE ev_projeto_saastizado 
	 END;
     
	 -- Concorrente ? --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_concorrente = CASE
	    WHEN trim(ev_concorrente) = 'ev_totvs_tem_concorrente_nao'              THEN 'Não'
        WHEN trim(ev_concorrente) = 'ev_totvs_tem_concorrente_nao_se_aplica'    THEN 'Não se aplica'
        WHEN trim(ev_concorrente) = 'ev_totvs_tem_concorrente_sim'              THEN 'Sim'
        WHEN trim(ev_concorrente) is null    THEN '-'
        ELSE ev_concorrente 
	 END;
     
     -- Linha de Produto --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_linha_produto = CASE
        WHEN trim(ev_linha_produto) = 'ev_erp_consinco_módulo_pdv'                                                     THEN 'Consinco - Módulo PDV'
		WHEN trim(ev_linha_produto) = 'ev_erp_consinco_módulos_backoffice'											   THEN 'Consinco - Módulos Backoffice'
		WHEN trim(ev_linha_produto) = 'ev_erp_consinco_módulos_comercial'  											   THEN 'Consinco - Módulos Comerciais'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_agro'                        THEN 'Totvs Plataforma - Linha Agro'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_business_performance'        THEN 'Totvs Plataforma - Linha Business Performance'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_construcao'                  THEN 'Totvs Plataforma - Linha Construção'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_distribuicao'                THEN 'Totvs Plataforma - Linha Distribuição'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_educacional'                 THEN 'Totvs Plataforma - Linha Educacional'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_financial_services'          THEN 'Totvs Plataforma - Linha Financial Services'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_hotelaria' 				   THEN 'Totvs Plataforma - Linha Hotelaria'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_juridico' 				   THEN 'Totvs Plataforma - Linha Jurídico'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_logistica'			       THEN 'Totvs Plataforma - Linha Logística'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_manufatura'				   THEN 'Totvs Plataforma - Linha Manufatura'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_outros'					   THEN 'Totvs Plataforma - Linha Outros'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_prestadores_de_servicos'     THEN 'Totvs Plataforma - Linha Prestadores de Serviços'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_rental' 					   THEN 'Totvs Plataforma - Linha Rental'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_saude'                       THEN 'Totvs Plataforma - Linha Saúde'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_techfin'                     THEN 'Totvs Plataforma - Linha Techfin'
		WHEN trim(ev_linha_produto) = 'ev_totvs_linha_de_produto_totvs_plataforma___linha_varejo' 					   THEN 'Totvs Plataforma - Linha Varejo'
        WHEN trim(ev_linha_produto) is null    THEN '-'
        ELSE ev_linha_produto
	 END;
     
      -- Inovação --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_inovacao = CASE
	    WHEN trim(ev_inovacao) = 'ev_totvs_inovacao_ev_assessment'            THEN 'Assessment'
        WHEN trim(ev_inovacao) = 'ev_totvs_inovacao_ev_get_demo'              THEN 'Get Demo'
        WHEN trim(ev_inovacao) = 'ev_totvs_inovacao_ev_smart_rfp'             THEN 'Smart RFP'
        WHEN trim(ev_inovacao) is null    THEN '-'
        ELSE ev_inovacao
	 END;
 
 	 -- Modelo atuação --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_modelo_atuacao = CASE
	    WHEN trim(ev_modelo_atuacao) = 'ev_totvs_modelo_de_atuacao_fast_track'       THEN 'Fast Track'
        WHEN trim(ev_modelo_atuacao) = 'ev_totvs_modelo_de_atuacao_poc'              THEN 'Poc'
        WHEN trim(ev_modelo_atuacao) = 'ev_totvs_modelo_de_atuacao_rmo'              THEN 'RMO'
        WHEN trim(ev_modelo_atuacao) is null    THEN '-'
        ELSE ev_modelo_atuacao
	 END;
     
     -- Atualiza campos com valor numérico válido---

     -- Zopa - Valor Zopa ideal de Não recorrente para o comprador --
 	 UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_ideal_nr_comprador= '0.00'
	  WHERE ev_zopa_valor_ideal_nr_comprador IS NULL OR TRIM(ev_zopa_valor_ideal_nr_comprador) = '';

	 UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_ideal_nr_comprador = REGEXP_REPLACE(ev_zopa_valor_ideal_nr_comprador, '[^0-9.,]', '')
	  WHERE ev_zopa_valor_ideal_nr_comprador REGEXP '[^0-9.,]';

	 UPDATE zendesk_tickets_transitoria
		SET ev_zopa_valor_ideal_nr_comprador = CASE 
	      -- Se houver vírgula no campo
	   WHEN ev_zopa_valor_ideal_nr_comprador LIKE '%,%' THEN 
			CONCAT(
			-- Parte 1: Tudo antes da última vírgula (removemos pontos e vírgulas extras aqui)
			REPLACE(REPLACE(SUBSTRING_INDEX(ev_zopa_valor_ideal_nr_comprador, ',', (LENGTH(ev_zopa_valor_ideal_nr_comprador) - LENGTH(REPLACE(ev_zopa_valor_ideal_nr_comprador, ',', '')))), ',', ''), '.', ''),
			'.', -- A última vírgula vira ponto
					-- Parte 2: Apenas os decimais (o que vem depois da última vírgula)
					SUBSTRING_INDEX(ev_zopa_valor_ideal_nr_comprador, ',', -1)
				)
			-- Se não houver vírgula, apenas removemos os pontos de milhar remanescentes
			ELSE REPLACE(ev_zopa_valor_ideal_nr_comprador, '.', '')
		END
	  WHERE ev_zopa_valor_ideal_nr_comprador LIKE '%,%' OR ev_zopa_valor_ideal_nr_comprador LIKE '%.%';
               
     -- Zopa - Menor valor aceitável pelo vendedor --
     UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_aceitavel_vendedor  = '0.00'
	  WHERE ev_zopa_valor_aceitavel_vendedor  IS NULL OR TRIM(ev_zopa_valor_aceitavel_vendedor ) = '';

	 UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_aceitavel_vendedor  = REGEXP_REPLACE(ev_zopa_valor_aceitavel_vendedor , '[^0-9.,]', '')
	  WHERE ev_zopa_valor_aceitavel_vendedor  REGEXP '[^0-9.,]';

	 UPDATE zendesk_tickets_transitoria
		SET ev_zopa_valor_aceitavel_vendedor  = CASE 
	      -- Se houver vírgula no campo
	   WHEN ev_zopa_valor_aceitavel_vendedor  LIKE '%,%' THEN 
			CONCAT(
			-- Parte 1: Tudo antes da última vírgula (removemos pontos e vírgulas extras aqui)
			REPLACE(REPLACE(SUBSTRING_INDEX(ev_zopa_valor_aceitavel_vendedor , ',', (LENGTH(ev_zopa_valor_aceitavel_vendedor ) - LENGTH(REPLACE(ev_zopa_valor_aceitavel_vendedor , ',', '')))), ',', ''), '.', ''),
			'.', -- A última vírgula vira ponto
					-- Parte 2: Apenas os decimais (o que vem depois da última vírgula)
					SUBSTRING_INDEX(ev_zopa_valor_aceitavel_vendedor , ',', -1)
				)
			-- Se não houver vírgula, apenas removemos os pontos de milhar remanescentes
			ELSE REPLACE(ev_zopa_valor_aceitavel_vendedor , '.', '')
		END
	  WHERE ev_zopa_valor_aceitavel_vendedor  LIKE '%,%' OR ev_zopa_valor_aceitavel_vendedor  LIKE '%.%';
	      
	 -- Zopa - Valor ideal de Serviço para o comprador --
	UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_ideal_servico_comprador  = '0.00'
	  WHERE ev_zopa_valor_ideal_servico_comprador  IS NULL OR TRIM(ev_zopa_valor_ideal_servico_comprador ) = '';

	 UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_ideal_servico_comprador  = REGEXP_REPLACE(ev_zopa_valor_ideal_servico_comprador , '[^0-9.,]', '')
	  WHERE ev_zopa_valor_ideal_servico_comprador  REGEXP '[^0-9.,]';

	 UPDATE zendesk_tickets_transitoria
		SET ev_zopa_valor_ideal_servico_comprador  = CASE 
	      -- Se houver vírgula no campo
	   WHEN ev_zopa_valor_ideal_servico_comprador  LIKE '%,%' THEN 
			CONCAT(
			-- Parte 1: Tudo antes da última vírgula (removemos pontos e vírgulas extras aqui)
			REPLACE(REPLACE(SUBSTRING_INDEX(ev_zopa_valor_ideal_servico_comprador , ',', (LENGTH(ev_zopa_valor_ideal_servico_comprador ) - LENGTH(REPLACE(ev_zopa_valor_ideal_servico_comprador , ',', '')))), ',', ''), '.', ''),
			'.', -- A última vírgula vira ponto
					-- Parte 2: Apenas os decimais (o que vem depois da última vírgula)
					SUBSTRING_INDEX(ev_zopa_valor_ideal_servico_comprador , ',', -1)
				)
			-- Se não houver vírgula, apenas removemos os pontos de milhar remanescentes
			ELSE REPLACE(ev_zopa_valor_ideal_servico_comprador , '.', '')
		END
	  WHERE ev_zopa_valor_ideal_servico_comprador  LIKE '%,%' OR ev_zopa_valor_ideal_servico_comprador  LIKE '%.%';
     
	 -- Faturamento Bruto Cliente --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_faturamento_bruto = '0.00'
	  WHERE ev_faturamento_bruto IS NULL OR TRIM(ev_faturamento_bruto) = '';
	
	 UPDATE zendesk_tickets_transitoria
	    SET ev_faturamento_bruto = REGEXP_REPLACE(ev_faturamento_bruto, '[^0-9.,]', '')
	  WHERE ev_faturamento_bruto REGEXP '[^0-9.,]';

	 UPDATE zendesk_tickets_transitoria
		SET ev_faturamento_bruto = CASE 
	      -- Se houver vírgula no campo
 	   WHEN ev_faturamento_bruto LIKE '%,%' THEN 
			CONCAT(
			-- Parte 1: Tudo antes da última vírgula (removemos pontos e vírgulas extras aqui)
			REPLACE(REPLACE(SUBSTRING_INDEX(ev_faturamento_bruto, ',', (LENGTH(ev_faturamento_bruto) - LENGTH(REPLACE(ev_faturamento_bruto, ',', '')))), ',', ''), '.', ''),
			'.', -- A última vírgula vira ponto
					-- Parte 2: Apenas os decimais (o que vem depois da última vírgula)
					SUBSTRING_INDEX(ev_faturamento_bruto, ',', -1)
				)
			-- Se não houver vírgula, apenas removemos os pontos de milhar remanescentes
			ELSE REPLACE(ev_faturamento_bruto, '.', '')
		END
		WHERE ev_faturamento_bruto LIKE '%,%' OR ev_faturamento_bruto LIKE '%.%';
        
		-- Valor de Serviços --
        UPDATE zendesk_tickets_transitoria
	       SET ev_valor_servicos  = '0.00'
	     WHERE ev_valor_servicos  IS NULL OR TRIM(ev_valor_servicos ) = '';

	    UPDATE zendesk_tickets_transitoria
	       SET ev_valor_servicos  = REGEXP_REPLACE(ev_valor_servicos , '[^0-9.,]', '')
	     WHERE ev_valor_servicos  REGEXP '[^0-9.,]';

	    UPDATE zendesk_tickets_transitoria
		    SET ev_valor_servicos  = CASE 
			  -- Se houver vírgula no campo
		   WHEN ev_valor_servicos  LIKE '%,%' THEN 
				CONCAT(
				-- Parte 1: Tudo antes da última vírgula (removemos pontos e vírgulas extras aqui)
				REPLACE(REPLACE(SUBSTRING_INDEX(ev_valor_servicos , ',', (LENGTH(ev_valor_servicos ) - LENGTH(REPLACE(ev_valor_servicos , ',', '')))), ',', ''), '.', ''),
				'.', -- A última vírgula vira ponto
						-- Parte 2: Apenas os decimais (o que vem depois da última vírgula)
						SUBSTRING_INDEX(ev_valor_servicos , ',', -1)
					)
				-- Se não houver vírgula, apenas removemos os pontos de milhar remanescentes
				ELSE REPLACE(ev_valor_servicos , '.', '')
			END
		  WHERE ev_valor_servicos  LIKE '%,%' OR ev_valor_servicos  LIKE '%.%';
        
       
	  -- Valor SAASTIZADO --
      UPDATE zendesk_tickets_transitoria
	     SET ev_projeto_saastizado  = '0.00'
	   WHERE ev_projeto_saastizado  IS NULL OR TRIM(ev_projeto_saastizado ) = '';

	  UPDATE zendesk_tickets_transitoria
	     SET ev_projeto_saastizado  = REGEXP_REPLACE(ev_projeto_saastizado , '[^0-9.,]', '')
	   WHERE ev_projeto_saastizado  REGEXP '[^0-9.,]';

	  UPDATE zendesk_tickets_transitoria
		 SET ev_projeto_saastizado  = CASE 
	      -- Se houver vírgula no campo
	    WHEN ev_projeto_saastizado  LIKE '%,%' THEN 
			CONCAT(
			-- Parte 1: Tudo antes da última vírgula (removemos pontos e vírgulas extras aqui)
			REPLACE(REPLACE(SUBSTRING_INDEX(ev_projeto_saastizado , ',', (LENGTH(ev_projeto_saastizado ) - LENGTH(REPLACE(ev_projeto_saastizado , ',', '')))), ',', ''), '.', ''),
			'.', -- A última vírgula vira ponto
					-- Parte 2: Apenas os decimais (o que vem depois da última vírgula)
					SUBSTRING_INDEX(ev_projeto_saastizado , ',', -1)
				)
			-- Se não houver vírgula, apenas removemos os pontos de milhar remanescentes
			ELSE REPLACE(ev_projeto_saastizado , '.', '')
		END
	   WHERE ev_projeto_saastizado  LIKE '%,%' OR ev_projeto_saastizado  LIKE '%.%';
                
   	  -- Valor Recorrente --     
	  UPDATE zendesk_tickets_transitoria
	     SET ev_valor_recorrente  = '0.00'
	   WHERE ev_valor_recorrente  IS NULL OR TRIM(ev_valor_recorrente ) = '';

	  UPDATE zendesk_tickets_transitoria
	     SET ev_valor_recorrente  = REGEXP_REPLACE(ev_valor_recorrente , '[^0-9.,]', '')
	   WHERE ev_valor_recorrente  REGEXP '[^0-9.,]';

	  UPDATE zendesk_tickets_transitoria
		 SET ev_valor_recorrente  = CASE 
	      -- Se houver vírgula no campo
	    WHEN ev_valor_recorrente  LIKE '%,%' THEN 
			CONCAT(
			-- Parte 1: Tudo antes da última vírgula (removemos pontos e vírgulas extras aqui)
			REPLACE(REPLACE(SUBSTRING_INDEX(ev_valor_recorrente , ',', (LENGTH(ev_valor_recorrente ) - LENGTH(REPLACE(ev_valor_recorrente , ',', '')))), ',', ''), '.', ''),
			'.', -- A última vírgula vira ponto
					-- Parte 2: Apenas os decimais (o que vem depois da última vírgula)
					SUBSTRING_INDEX(ev_valor_recorrente , ',', -1)
				)
			-- Se não houver vírgula, apenas removemos os pontos de milhar remanescentes
			ELSE REPLACE(ev_valor_recorrente , '.', '')
		 END
	   WHERE ev_valor_recorrente  LIKE '%,%' OR ev_valor_recorrente  LIKE '%.%';
               
	 -- Valor CDU --    
	 UPDATE zendesk_tickets_transitoria
	    SET ev_valor_cdu  = '0.00'
	  WHERE ev_valor_cdu  IS NULL OR TRIM(ev_valor_cdu ) = '';

	 UPDATE zendesk_tickets_transitoria
	    SET ev_valor_cdu  = REGEXP_REPLACE(ev_valor_cdu , '[^0-9.,]', '')
	  WHERE ev_valor_cdu  REGEXP '[^0-9.,]';

	 UPDATE zendesk_tickets_transitoria
		SET ev_valor_cdu  = CASE 
	      -- Se houver vírgula no campo
	   WHEN ev_valor_cdu  LIKE '%,%' THEN 
			CONCAT(
			-- Parte 1: Tudo antes da última vírgula (removemos pontos e vírgulas extras aqui)
			REPLACE(REPLACE(SUBSTRING_INDEX(ev_valor_cdu , ',', (LENGTH(ev_valor_cdu ) - LENGTH(REPLACE(ev_valor_cdu , ',', '')))), ',', ''), '.', ''),
			'.', -- A última vírgula vira ponto
					-- Parte 2: Apenas os decimais (o que vem depois da última vírgula)
					SUBSTRING_INDEX(ev_valor_cdu , ',', -1)
				)
			-- Se não houver vírgula, apenas removemos os pontos de milhar remanescentes
			ELSE REPLACE(ev_valor_cdu , '.', '')
		END
	  WHERE ev_valor_cdu  LIKE '%,%' OR ev_valor_cdu  LIKE '%.%';
        
        
END //

DELIMITER ;