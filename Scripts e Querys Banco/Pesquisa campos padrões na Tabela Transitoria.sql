-- Query pesquisa do conteúdo dos campos ajustados na tabela Transitória
Select ev_modelo_atendimento,count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_tipo_atendimento, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_linha_erp, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_unidade_venda, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_prospect_base, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_segmento, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_necessario_outros_times, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_primeira_visita, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_reversao_churn, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_status_oportunidade, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_status_forecast, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_e_oferta, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_projeto_saastizado, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_concorrente, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_linha_produto, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_inovacao, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_modelo_atuacao, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_area_do_solicitante, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_publico_material, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_equipe_envolvida, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;
Select ev_projeto_relacao_oferta, count(*) from totvs_ev_datalake.zendesk_tickets_transitoria group by 1 order by 1;



