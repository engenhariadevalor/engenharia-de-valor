
CREATE TABLE `ev_tickets_zendesk` (
  `ticket_id` bigint DEFAULT NULL,
  `assignee_name` varchar(255),
  `brand_name` text,
  `date_created` datetime DEFAULT NULL,
  `date_first_assigned` datetime DEFAULT NULL,
  `date_last_assigned` datetime DEFAULT NULL,
  `date_last_comment` datetime DEFAULT NULL,
  `date_requester_update` datetime DEFAULT NULL,
  `date_solved` datetime DEFAULT NULL,
  `date_status_updated` datetime DEFAULT NULL,
  `date_updated` datetime DEFAULT NULL,
  `description` text,
  `group_name` text,
  `number_changes_assignee` bigint DEFAULT NULL,
  `organization_name` text,
  `requester_name` text,
  `submitter_name` text,
  `ticket_priority` text,
  `ticket_form_name` text,
  `ticket_status` text,
  `ticket_subject` text,
  `type` text,
  `aging_backlog` bigint DEFAULT NULL,
  `fundido` bigint DEFAULT NULL,
  `group_id` bigint DEFAULT NULL,
  `first_sla_date` datetime DEFAULT NULL,
  `follower_ids` text,
  `ev_issue_jira_id` text,
  `ev_catalogo_level1` varchar(255),
  `ev_catalogo_level2` varchar(255),
  `ev_catalogo_level3` varchar(255),
  `ev_catalogo_level4` varchar(255),
  `ev_participantes` text,
  `ev_gsn` text,
  `ev_modelo_atendimento` text,
  `ev_linha_erp` varchar(255),
  `ev_data_estimada_fechamento` text,
  `ev_unidade_venda` varchar(255),
  `ev_codigo_cliente` varchar(100),
  `ev_razao_social_cliente` varchar(255),
  `ev_cidade_cliente` text,
  `ev_segmento` varchar(255),
  `ev_cnae_cliente` text,
  `ev_prospect_base` varchar(20),
  `ev_cnpj` text,
  `ev_cargo_do_cliente` varchar(255),
  `ev_celular_do_cliente` varchar(255),
  `ev_email_do_cliente` varchar(255),
  `ev_site_do_cliente` text,
  `ev_cargo_do_solicitante` varchar(255),
  `ev_area_do_solicitante` varchar(50),
  `ev_data_material_pronto` text,
  `ev_publico_material` varchar(50),
  `ev_externo_link_material` text,
  `ev_projeto_relacao_oferta` varchar(20),
  `ev_equipe_envolvida` varchar(255),
  `ev_squad` varchar(20),
  `ev_equipe_triagem` text,
  `ev_status_triagem` text,
  `ev_tipo_atendimento` varchar(50),
  `ev_necessario_outros_times` varchar(50),
  `ev_sugestao_produtos` text,
  `ev_total_colaboradores` text,
  `ev_primeira_visita` varchar(20),
  `ev_reversao_churn` varchar(20),
  `ev_novo_licenciamento` text,
  `ev_contato_esn` text,
  `ev_zopa_valor_ideal_nr_comprador` decimal(15,2),
  `ev_zopa_valor_aceitavel_vendedor` decimal(15,2),
  `ev_zopa_valor_ideal_servico_comprador` decimal(15,2),
  `ev_faturamento_bruto` text,
  `ev_prazo_atendimento` text,
  `ev_gpp` text,
  `ev_concorrente` varchar(50),
  `ev_linha_produto` varchar(255),
  `ev_servicos_operacao` text,
  `ev_inovacao` varchar(20),
  `ev_produtos_oferecidos` text,
  `ev_motivo_perda` text,
  `ev_modelo_atuacao` varchar(20),
  `ev_coordenador_atendimento` text,
  `ev_prazo_entrega_rfiq` text,
  `ev_status_oportunidade` varchar(50),
  `ev_status_forecast` varchar(50),
  `ev_e_oferta` varchar(20),
  `ev_oferta_oferecida` text,
  `ev_numero_oportunidade` varchar(255),
  `ev_valor_servicos` decimal(15,2),
  `ev_projeto_saastizado` varchar(20),
  `ev_valor_recorrente` decimal(15,2),
  `ev_valor_cdu` decimal(15,2),
  `ev_valor_proposta` decimal(15,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


ALTER TABLE ev_tickets_zendesk ADD INDEX (ticket_id);
ALTER TABLE ev_tickets_zendesk ADD INDEX (assignee_name);
ALTER TABLE ev_tickets_zendesk ADD INDEX (date_created);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_catalogo_level1);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_catalogo_level2);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_catalogo_level3);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_catalogo_level4);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_linha_erp);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_unidade_venda);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_codigo_cliente);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_razao_social_cliente);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_segmento);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_prospect_base);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_area_do_solicitante);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_publico_material);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_projeto_relacao_oferta);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_equipe_envolvida);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_tipo_atendimento);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_necessario_outros_times);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_primeira_visita);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_reversao_churn);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_linha_produto);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_inovacao);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_modelo_atuacao);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_status_oportunidade);
ALTER TABLE ev_tickets_zendesk ADD INDEX (ev_status_forecast);
