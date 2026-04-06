-- Julio Cesar Guerato / Março - 2026 --
-- Implementar Trigger / Testar  --
USE totvs_ev_datalake
SET SQL_SAFE_UPDATES = 0;

-- Limpa as tabelas para teste --
DROP TRIGGER IF EXISTS trigger_zendesk_tickets_transitoria;
delete from zendesk_processamento_work;
delete from ev_tickets_zendesk_dtatualiz;

-- Executar o Script da Trigger antes

-- Inserir 1 registro na tabela de processamento para disparar a Trigger
insert into zendesk_processamento_work
select * From teste limit 1;

-- Volta a reativar a trava de segurança --
SET SQL_SAFE_UPDATES = 1;


