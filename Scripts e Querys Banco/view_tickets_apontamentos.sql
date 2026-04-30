-- View Totalizando os apontamentos por ticket: Total Horas, Tipo de Apontamento e Quantidade de Evs diferentes
CREATE OR REPLACE VIEW view_tickets_apontamentos AS 
SELECT 
    t.ticket_id, 
    t.assignee_name, 
    t.ticket_status, 
    t.date_created, 
    t.date_solved, 
    t.ev_numero_oportunidade, 
    t.ev_unidade_venda, 
    t.ev_segmento, 
    t.ev_status_oportunidade, 
    t.ev_status_forecast, 
    t.ev_razao_social_cliente, 
    t.ev_faturamento_bruto, 
    t.ev_prospect_base, 
    t.ev_catalogo_level3, 
    t.ev_catalogo_level4, 
    t.date_updated,
    a.tipo, -- Novo campo adicionado aqui
    COALESCE(SUM(a.horasapont), 0) AS total_horas_apontadas,
    COUNT(DISTINCT a.id_ev) AS qtd_evs
FROM 
    ev_tickets_zendesk t
LEFT JOIN 
    ev_apontamentos a ON t.ticket_id = a.id_ticket
GROUP BY 
    t.ticket_id, 
    t.assignee_name, 
    t.ticket_status, 
    t.date_created, 
    t.date_solved, 
    t.ev_numero_oportunidade, 
    t.ev_unidade_venda, 
    t.ev_segmento, 
    t.ev_status_oportunidade, 
    t.ev_status_forecast, 
    t.ev_razao_social_cliente, 
    t.ev_faturamento_bruto, 
    t.ev_prospect_base, 
    t.ev_catalogo_level3, 
    t.ev_catalogo_level4, 
    t.date_updated,
    a.tipo; 