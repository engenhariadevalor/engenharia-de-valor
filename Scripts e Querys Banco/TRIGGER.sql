-- Julio Cesar Guerato / Março - 2026 --
-- Dispara a TRIGGER logo que a tabela zendesk_processamento_work for preenchida        --
-- Tabela é populado pelo extracaoclientestenant.py que roda no CAROL APPS diariamente  --
-- Assim que termina o processamento o CAROL APPS a TRIGGER deverá ser disparada        --
-- A TRIGGER fará o processamento em cima da tabela ZENDESK_TICKETS_TENANT e irá gravar --
-- a tabela ZENDESK_TICKETS_TRANSITORIA e ao final, poupar a tabela EV_TICKETS_ZENDESK  --
-- que é a tabela ofical para indicadores                                               --
DELIMITER //
CREATE TRIGGER trigger_zendesk_tickets_transitoria
AFTER INSERT ON zendesk_processamento_work
FOR EACH ROW
BEGIN
    -- Variável para guardar registros
    DECLARE total_registros_tenant INT;
    DECLARE total_registros_transitoria INT;
    DECLARE erro_codigo int;
    DECLARE erro_texto text;
    
    -- Captura qualquer erro e grava no log de execução  --
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    Begin
       GET DIAGNOSTICS CONDITION 1 
        erro_codigo = MYSQL_ERRNO,
        erro_texto = MESSAGE_TEXT;
		
        INSERT INTO zendesk_processamento_erros (data_processamento, codigo_erro, mensagem_erro)
        VALUES (now() , erro_codigo, erro_texto);
	END;
    
    -- Reseta e ajusta hora horario Brasil --
    SET time_zone = '-03:00';
    SET SQL_SAFE_UPDATES = 0;
    
    -- Elimina registros da Tenant que forem diferentes do ev_catalogo_level1 diferente de Engenharia de valor --
    Delete from zendesk_tickets_tenant Where UPPER(ev_catalogo_level1) <> 'ENGENHARIA DE VALOR TOTVS';
    Delete from zendesk_tickets_tenant Where ev_catalogo_level1 is null;
    
    -- Quantidade de registros da tabela zendesk_tickets_tenant --
    -- Tabela original vinda da Tenant do Zendesk carregada via Script --
    SELECT COUNT(*) INTO total_registros_tenant FROM zendesk_tickets_tenant;
    
    -- Limpa a tabela zendesk em tabela de trabalho - zendesk_tickets_transitoria --
    delete from zendesk_tickets_transitoria where 1=1;
    
    -- Insere tickets capturados do zendesk em tabela de trabalho - zendesk_tickets_transitoria --
    INSERT INTO zendesk_tickets_transitoria
    select * from zendesk_tickets_tenant;
        
    -- Atualiza o Level dos Catalogos --
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Anállise de Oportunidades e geração de valor para clientes e Prospects',
		   ev_ajuste_level    = 1 
	 WHERE ticket_id = 965026
       and ev_ajuste_level    = 0;
	      
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Setor Público - SPUB',
		   ev_catalogo_level4 = 'Análise de Edital para Clientes e Prospects',
           ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Análise de Edital para Clientes'
	   AND ev_catalogo_level4 IS NULL
       AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Setor Público - SPUB',
		   ev_catalogo_level4 = 'Análise de Edital para Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Análise de Edital para Prospects'
	   AND ev_catalogo_level4 IS NULL
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Anállise de Oportunidades e geração de valor para clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',
           ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Análise de Oportunidades e Geração de Valor para Clientes'
	   AND ev_catalogo_level4 IS NULL
       AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Anállise de Oportunidades e geração de valor para clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',
           ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Análise de Oportunidades e Geração de Valor para Prospects'
	   AND ev_catalogo_level4 IS NULL
       AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Anállise de Oportunidades e geração de valor para clientes e Prospects',
           ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Análise de TR para Clientes'
	   AND ev_catalogo_level4 IS NULL
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
   
   	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Setor Público - SPUB',
		   ev_catalogo_level4 = 'Análise de TR para Clientes e Prospects',
           ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Análise de TR para Clientes'
	   AND ev_catalogo_level4 IS NULL
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
                 
   	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Setor Público - SPUB',
		   ev_catalogo_level4 = 'Análise de TR para Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',     
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Análise de TR para Prospects'
	   AND ev_catalogo_level4 IS NULL
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Design de negócios: Demanda interna TOTVS',
		   ev_catalogo_level4 = 'Apoio a Eventos',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',   
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Apoio a Eventos'
	   AND ev_catalogo_level4 IS NULL
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Solicitação de Projeto com HUB de Soluções (Value Assessment) - Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',   
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Assessment'
	   AND ev_catalogo_level4 = 'Assessment'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Demonstração para Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',   
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Assessment'
	   AND ev_catalogo_level4 = 'Demo'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Design de negócios: Demanda interna TOTVS',
		   ev_catalogo_level4 = 'Assessoria estratégica',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',   
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Assessoria estratégica (Área Interna)'
	   AND ev_catalogo_level4 is null
       AND ev_catalogo_level2 = 'Engenharia de Valor TOTVS'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
      
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Design de negócios: Demanda cliente TOTVS',
		   ev_catalogo_level4 = 'Apoio Estratégico em Oportunidade',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',   
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Assessoria estratégica (Cliente totvs)'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
      
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Design de negócios: Demanda cliente TOTVS',
		   ev_catalogo_level4 = 'Assessoria estratégica',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',            
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Assessoria Técnica (Área interna)'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Design de negócios: Demanda cliente TOTVS',
		   ev_catalogo_level4 = 'Assessorias',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',           
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Assessoria técnica (Cliente totvs)'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Demonstração para Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',              
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Atendimento Especialista'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Demonstração para Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',              
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Demo'
	   AND ev_catalogo_level4 = 'Demo'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
      
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Design de negócios: Demanda cliente TOTVS',
		   ev_catalogo_level4 = 'Apoio Estratégico em Oportunidade',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS', 
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Design de Negócios'
	   AND ev_catalogo_level4 = 'Design de Negócios'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Solicitação de Projeto com HUB de Soluções (Value Assessment) - Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS', 
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Dimensionamento'
	   AND ev_catalogo_level4 = 'Assessment'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Demonstração para Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',            
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Dimensionamento'
	   AND ev_catalogo_level4 = 'Demo'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Anállise de Oportunidades e geração de valor para clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS', 
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Dimensionamento'
	   AND ev_catalogo_level4 = 'Dimensionamento'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;
      
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Design de negócios: Demanda interna TOTVS',
		   ev_catalogo_level4 = 'Estratégias e Planejamentos',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS', 
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Estratégia GTM (Go To Market)'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Design de negócios: Demanda interna TOTVS',
		   ev_catalogo_level4 = 'Estratégias e Planejamentos',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',            
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Estratégias e Planejamentos'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
   
   	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Solicitação de Projeto com HUB de Soluções (Value Assessment) - Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',    
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Imersão 360'
	   AND ev_catalogo_level4 = 'Assessment'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Anállise de Oportunidades e geração de valor para clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',    
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Imersão 360'
	   AND ev_catalogo_level4 = 'Dimensionamento'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
   
   	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Solicitação Imersão 360º',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',           
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Imersão 360'
	   AND ev_catalogo_level4 = 'Imersão 360'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Design de negócios: Demanda interna TOTVS',
		   ev_catalogo_level4 = 'Kit de Vendas',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',             
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Kit de Vendas'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Design de negócios: Demanda interna TOTVS',
		   ev_catalogo_level4 = 'Apoio Estratégico em Oportunidade',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS', 
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Oportunidade'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  

	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Solução de RFI/RFP para clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS', 
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'RFP'
	   AND ev_catalogo_level4 = 'RFP'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Design de negócios: Demanda interna TOTVS',
		   ev_catalogo_level4 = 'Rotina',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',            
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Rotina'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Solução de RFI/RFP para clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',             
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Seleção de RFI/RFP para Clientes'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_catalogo_level4 is null;
	

	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Solução de RFI/RFP para clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',             
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Seleção de RFI/RFP para Prospects'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_catalogo_level4 is null
	   AND ev_ajuste_level    = 0;  
   
   	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Solicitação Imersão 360º',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',             
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Solicitação de Imersão 360'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'     
	   AND ev_catalogo_level4 is null
	   AND ev_ajuste_level    = 0;  
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Demonstração para Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',    
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Solicitação de Pré-venda - Demonstrações para Clientes'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_catalogo_level4 is null
	   AND ev_ajuste_level    = 0;  
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Demonstração para Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',   
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Solicitação de Pré-venda - Demonstrações para Prospects'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
   
   	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Solicitação de Projeto com HUB de Soluções (Value Assessment) - Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS', 
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Solicitação de Projeto com HUB de Soluções (Value Assessment) - Clientes'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
   
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Solicitação de Projeto com HUB de Soluções (Value Assessment) - Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS', 
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Solicitação de Projeto com HUB de Soluções (Value Assessment) - Prospects'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'Solicitação de Proposta Padrões (Fast Track)',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS', 
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Solicitação de Proposta de Banco de Horas'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'TOTVS Day - Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS', 
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'TOTVS Day'
	   AND ev_catalogo_level4 = 'TOTVS Day'
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'TOTVS Day - Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'TOTVS Day - Clientes'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0;  
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'Atendimento de Oportunidades para Clientes e Prospects',
		   ev_catalogo_level4 = 'TOTVS Day - Clientes e Prospects',
		   ev_catalogo_level2 = 'Engenharia de Valor TOTVS',
           ev_catalogo_level1 = 'Engenharia de Valor TOTVS',
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'TOTVS Day - Prospects'
	   AND ev_catalogo_level4 is null
	   AND upper(ev_catalogo_level2) = 'ENGENHARIA DE VALOR TOTVS'
       AND upper(ev_catalogo_level1) = 'ENGENHARIA DE VALOR TOTVS'
	   AND ev_ajuste_level    = 0; 
   
   	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'RD Station',
		   ev_catalogo_level4 = 'Arquitetura',
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Arquitetura'
       AND ev_catalogo_level2 = 'RD Station'
	   AND ev_catalogo_level4 is null
	   AND ev_ajuste_level    = 0; 
       
	UPDATE zendesk_tickets_transitoria
	   SET ev_catalogo_level3 = 'RD Station',
		   ev_catalogo_level4 = 'Demonstração',
		   ev_ajuste_level    = 1 
	 WHERE ev_catalogo_level3 = 'Arquitetura'
       AND ev_catalogo_level2 = 'RD Station'
	   AND ev_catalogo_level4 = 'Rd Conversas'
	   AND ev_ajuste_level    = 0; 
        
    -- Atualiza campos da tabela de trabalho zendesk_tickets_transitoria --
    -- Objetivo de colocar os campos no padrão de serem utilizados --
        
    -- Modelo de atendimento --
    UPDATE zendesk_tickets_transitoria
    SET ev_modelo_atendimento = CASE 
        WHEN trim(ev_modelo_atendimento)      = 'qual_sera_o_modelo_de_atendimento_remoto'           THEN 'Remoto'
        WHEN trim(ev_modelo_atendimento)      = 'qual_sera_o_modelo_de_atendimento_ambos'        	 THEN 'Ambos'
        WHEN trim(ev_modelo_atendimento)      = 'qual_sera_o_modelo_de_atendimento_presencial'       THEN 'Presencial'
		WHEN trim(ev_modelo_atendimento) is null  THEN '-'
        ELSE ev_modelo_atendimento
     END;

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
        WHEN trim(ev_segmento) is null    THEN '-'
		ELSE ev_segmento
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
     
     -- Area do Solicitante --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_area_do_solicitante = CASE
	    WHEN trim(ev_area_do_solicitante) = 'qual_a_sua_area_comercial'             THEN 'Comercial'
        WHEN trim(ev_area_do_solicitante) = 'qual_a_sua_area_engenharia_de_valor'   THEN 'Engenharia de Valor'
        WHEN trim(ev_area_do_solicitante) = 'qual_a_sua_area_operacoes'   			THEN 'Operações'
        WHEN trim(ev_area_do_solicitante) is null    THEN '-'
        ELSE ev_area_do_solicitante
	 END;
     
     -- Publico do Material --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_publico_material = CASE
	    WHEN trim(ev_publico_material) = 'publico_do_material_executivo'    THEN 'Executivo'
        WHEN trim(ev_publico_material) = 'publico_do_material_outros'   	THEN 'Outros'
        WHEN trim(ev_publico_material) = 'publico_do_material_time'   		THEN 'Time'
        WHEN trim(ev_publico_material) is null    							THEN '-'
        ELSE ev_publico_material
	 END;
     
	 -- Equipe Envolvida --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_equipe_envolvida = CASE
	    WHEN trim(ev_equipe_envolvida) = 'ev_totvs_equipe_envolvida_comercial'      THEN 'Comercial'
        WHEN trim(ev_equipe_envolvida) = 'ev_totvs_equipe_envolvida_especialista'   THEN 'Especialista'
        WHEN trim(ev_equipe_envolvida) = 'ev_totvs_equipe_envolvida_ev'   			THEN 'Engenharia Valor'
		WHEN trim(ev_equipe_envolvida) = 'ev_totvs_equipe_envolvida_Outros'   		THEN 'Outros'
        WHEN trim(ev_equipe_envolvida) is null    THEN '-'
        ELSE ev_equipe_envolvida
	 END;
     
	  -- Projeto Relação x Oferta --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_projeto_relacao_oferta = CASE
	    WHEN trim(ev_projeto_relacao_oferta) = 'ev_totvs_o_projeto_tem_alguma_oferta_nova_em_relação_à_totvs_ou_uma_arquitetura_muito_complexa_nao_'               THEN 'Não'
        WHEN trim(ev_projeto_relacao_oferta) = 'ev_totvs_o_projeto_tem_alguma_oferta_nova_em_relação_à_totvs_ou_uma_arquitetura_muito_complexa_nao_se_aplica_'     THEN 'Não se aplica'
        WHEN trim(ev_projeto_relacao_oferta) = 'ev_totvs_o_projeto_tem_alguma_oferta_nova_em_relação_à_totvs_ou_uma_arquitetura_muito_complexa_sim_'   			THEN 'Sim'
        WHEN trim(ev_projeto_relacao_oferta) is null    THEN '-'
        ELSE ev_projeto_relacao_oferta 
	 END;
     
	 -- Status Triagem --
	 UPDATE zendesk_tickets_transitoria
	    SET ev_status_triagem = CASE
	    WHEN trim(ev_status_triagem) = 'ev_status_triagem_1__triagem'                        THEN 'Triagem' 
        WHEN trim(ev_status_triagem) = 'ev_status_triagem_ajuste_de_campos_ev'               THEN 'Ajuste de Campos EV' 
        WHEN trim(ev_status_triagem) = 'ev_status_triagem_qualificação'                      THEN 'Qualificação' 
        WHEN trim(ev_status_triagem) = 'ev_status_triagem_retorno_de_esn'                    THEN 'Retorno do ESN' 
        WHEN trim(ev_status_triagem) = 'ev_status_triagem_validação_triagem'                 THEN 'Validação Triagem' 
        WHEN trim(ev_status_triagem) is null    THEN '-'
        ELSE ev_status_triagem
	 END;
         
     -- Atualiza campos com valor numérico válido, devido não existir um formato padronizado ---
     -- Vários campos possuem no conteúdo original letras, numeros, sem padrão.

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
      
      UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_ideal_nr_comprador = '0.00'
	  WHERE trim(ev_zopa_valor_ideal_nr_comprador) = '.' or trim(ev_zopa_valor_ideal_nr_comprador) = ',';

      UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_ideal_nr_comprador = '0.00'
	  WHERE (CHAR_LENGTH(ev_zopa_valor_ideal_nr_comprador) - CHAR_LENGTH(REPLACE(LOWER(ev_zopa_valor_ideal_nr_comprador), '.', '')))>1;
           
     -- Zopa - Menor valor aceitável pelo vendedor --
     UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_aceitavel_vendedor  = '0.00'
	  WHERE ev_zopa_valor_aceitavel_vendedor  IS NULL OR TRIM(ev_zopa_valor_aceitavel_vendedor ) = '';

	 UPDATE zendesk_tickets_transitoria
         SET ev_zopa_valor_aceitavel_vendedor = 
             CASE 
              -- Se houver qualquer letra (a-z) ou caractere especial (exceto números, ponto e vírgula)
             WHEN ev_zopa_valor_aceitavel_vendedor REGEXP '[a-zA-Z]' THEN '0'
             -- Caso contrário, faz a limpeza mantendo apenas os números e separadores
             ELSE REGEXP_REPLACE(ev_zopa_valor_aceitavel_vendedor, '[^0-9.,]', '')
          END
     WHERE ev_zopa_valor_aceitavel_vendedor REGEXP '[^0-9.,]';
    
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
      
	 UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_aceitavel_vendedor = '0.00'
	  WHERE trim(ev_zopa_valor_aceitavel_vendedor) = '.' or trim(ev_zopa_valor_aceitavel_vendedor) = ',';
      
	 UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_aceitavel_vendedor = '0.00'
	  WHERE (CHAR_LENGTH(ev_zopa_valor_aceitavel_vendedor) - CHAR_LENGTH(REPLACE(LOWER(ev_zopa_valor_aceitavel_vendedor), '.', '')))>1;
                
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
      
	  UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_ideal_servico_comprador = '0.00'
	  WHERE trim(ev_zopa_valor_ideal_servico_comprador) = '.' or trim(ev_zopa_valor_ideal_servico_comprador) = ',';
      
	  UPDATE zendesk_tickets_transitoria
	    SET ev_zopa_valor_ideal_servico_comprador = '0.00'
	  WHERE (CHAR_LENGTH(ev_zopa_valor_ideal_servico_comprador) - CHAR_LENGTH(REPLACE(LOWER(ev_zopa_valor_ideal_servico_comprador), '.', '')))>1;
           
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
      
      UPDATE zendesk_tickets_transitoria
	    SET ev_valor_servicos = '0.00'
	  WHERE trim(ev_valor_servicos) = '.' or trim(ev_valor_servicos) = ',';
      
	  UPDATE zendesk_tickets_transitoria
	    SET ev_valor_servicos = '0.00'
	  WHERE (CHAR_LENGTH(ev_valor_servicos) - CHAR_LENGTH(REPLACE(LOWER(ev_valor_servicos), '.', '')))>1;
                
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
       
       UPDATE zendesk_tickets_transitoria
	      SET ev_valor_recorrente = '0.00'
	   WHERE trim(ev_valor_recorrente) = '.' or trim(ev_valor_recorrente) = ',';
       
       UPDATE zendesk_tickets_transitoria
	      SET ev_valor_recorrente = '0.00'
	    WHERE (CHAR_LENGTH(ev_valor_recorrente) - CHAR_LENGTH(REPLACE(LOWER(ev_valor_recorrente), '.', '')))>1;
               
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
	  WHERE ev_valor_cdu  LIKE '%,%' or ev_valor_cdu  LIKE '%.%';
      
	  UPDATE zendesk_tickets_transitoria
	      SET ev_valor_cdu = '0.00'
	   WHERE trim(ev_valor_cdu ) = '.' or trim(ev_valor_cdu ) = ','; 
       
	  UPDATE zendesk_tickets_transitoria
	     SET ev_valor_recorrente = '0.00'
	   WHERE (CHAR_LENGTH(ev_valor_cdu) - CHAR_LENGTH(REPLACE(LOWER(ev_valor_cdu), '.', '')))>1;
       
	 -- Valor Proposta --    
	 UPDATE zendesk_tickets_transitoria
	    SET ev_valor_proposta  = '0.00'
	  WHERE ev_valor_proposta  IS NULL OR TRIM(ev_valor_proposta ) = '';

	 UPDATE zendesk_tickets_transitoria
	    SET ev_valor_proposta  = REGEXP_REPLACE(ev_valor_proposta , '[^0-9.,]', '')
	  WHERE ev_valor_proposta  REGEXP '[^0-9.,]';

	 UPDATE zendesk_tickets_transitoria
		SET ev_valor_proposta  = CASE 
	      -- Se houver vírgula no campo
	   WHEN ev_valor_proposta  LIKE '%,%' THEN 
			CONCAT(
			-- Parte 1: Tudo antes da última vírgula (removemos pontos e vírgulas extras aqui)
			REPLACE(REPLACE(SUBSTRING_INDEX(ev_valor_proposta , ',', (LENGTH(ev_valor_proposta ) - LENGTH(REPLACE(ev_valor_proposta , ',', '')))), ',', ''), '.', ''),
			'.', -- A última vírgula vira ponto
					-- Parte 2: Apenas os decimais (o que vem depois da última vírgula)
					SUBSTRING_INDEX(ev_valor_proposta , ',', -1)
				)
			-- Se não houver vírgula, apenas removemos os pontos de milhar remanescentes
			ELSE REPLACE(ev_valor_proposta , '.', '')
		END
	  WHERE ev_valor_proposta  LIKE '%,%' or ev_valor_proposta  LIKE '%.%';
      
	  UPDATE zendesk_tickets_transitoria
	     SET ev_valor_proposta = '0.00'
	  WHERE trim(ev_valor_proposta ) = '.' or trim(ev_valor_proposta ) = ','; 
      
      UPDATE zendesk_tickets_transitoria
	     SET ev_valor_proposta = '0.00'
	   WHERE (CHAR_LENGTH(ev_valor_proposta) - CHAR_LENGTH(REPLACE(LOWER(ev_valor_proposta), '.', '')))>1;
      
	  -- Limpa a Tabela de data de atualização --
	  Delete from ev_tickets_zendesk_dtatualiz Where 1=1;
	  
	  -- Limpa a Tabela Tickets Oficial - base para Locker --
	  Delete from ev_tickets_zendesk Where 1=1;
      
	  -- Total de registros da tabela Transitoria --
	  SELECT COUNT(*) INTO total_registros_transitoria FROM zendesk_tickets_transitoria;
	  
	  -- INSERE OS REGISTROS NA TABELA EV_TICKETS_ZENDESK OFICIAL DA ENG DE VALOR -------
	  insert into ev_tickets_zendesk
	  select 
		ticket_id,              			     SUBSTRING(assignee_name,1,255),         		brand_name,                	 			 		date_created,              			     date_first_assigned, 
		date_last_assigned,     				 date_last_comment,      			     		date_requester_update,     		 				date_solved,               			     date_status_updated,
		date_updated,           				 description,            			     		group_name,                		 				number_changes_assignee,  			     organization_name, 
		requester_name,         				 submitter_name,         			     		ticket_priority,           		 				ticket_form_name,          			 	 ticket_status, 
		ticket_subject,         				 type,                   		         		aging_backlog,             		 				fundido,                   			 	 group_id, 
		first_sla_date,         				 follower_ids,                           		ev_issue_jira,                     				SUBSTRING(ev_catalogo_level1,1,255),     SUBSTRING(ev_catalogo_level2,1,255),   SUBSTRING(ev_catalogo_level3,1,255),   SUBSTRING(ev_catalogo_level4,1,255),
		ev_participantes,        				 ev_gsn,                 			     		ev_modelo_atendimento,     		 				SUBSTRING(ev_linha_erp,1,255),  		 ev_data_estimada_fechamento, 
		SUBSTRING(ev_unidade_venda,1,255),       SUBSTRING(ev_codigo_cliente,1,100),     		SUBSTRING(ev_razao_social_cliente,1,255), 		ev_cidade_cliente,        			     SUBSTRING(ev_segmento,1,255),
		ev_cnae_cliente,        				 SUBSTRING(ev_prospect_base,1,20),       		ev_cnpj,                   		 
		SUBSTRING(ev_cargo_do_cliente,1,255),	 SUBSTRING(ev_celular_do_cliente,1,255),    	SUBSTRING(ev_email_do_cliente,1,255),           ev_site_do_cliente, 					 SUBSTRING(ev_cargo_do_solicitante,1,255),
		SUBSTRING(ev_area_do_solicitante,1,50),  ev_data_material_pronto,                       SUBSTRING(ev_publico_material,1,50),            ev_externo_link_material,                SUBSTRING(ev_projeto_relacao_oferta,1,20),
		SUBSTRING(ev_equipe_envolvida,1,255),    SUBSTRING(ev_squad,1,20), 						ev_equipe_triagem, 					   		    ev_status_triagem,
		SUBSTRING(ev_tipo_atendimento,1,255),    SUBSTRING(ev_necessario_outros_times,1,50),    ev_sugestao_produtos,    			            ev_total_colaboradores,     		     SUBSTRING(ev_primeira_visita,1,20),    		 SUBSTRING(ev_reversao_churn,1,20),   ev_novo_licenciamento, 
		ev_contato_esn,        
		COALESCE(CAST(NULLIF(ev_zopa_valor_ideal_nr_comprador, '') AS DECIMAL(15,2)), 0.00), 
		COALESCE(CAST(NULLIF(ev_zopa_valor_aceitavel_vendedor, '') AS DECIMAL(15,2)), 0.00),  
		COALESCE(CAST(NULLIF(ev_zopa_valor_ideal_servico_comprador, '') AS DECIMAL(15,2)), 0.00), 
		ev_faturamento_bruto, 
		ev_prazo_atendimento,   				 ev_gpp, 										SUBSTRING(ev_concorrente,1,50),                 SUBSTRING(ev_linha_produto,1,50),         ev_servicos_operacao, 					 SUBSTRING(ev_inovacao,1,20), 
		ev_produtos_oferecidos, 			     ev_motivo_perda, 								SUBSTRING(ev_modelo_atuacao,1,20),   			ev_coordenador_atendimento,        		  ev_prazo_entrega_rfiq,                     SUBSTRING(ev_status_oportunidade,1,50),
		SUBSTRING(ev_status_forecast,1,50),      SUBSTRING(ev_e_oferta,1,20),               	ev_oferta_oferecida,               				SUBSTRING(ev_numero_oportunidade,1,255), 
		COALESCE(CAST(NULLIF(ev_valor_servicos, '') AS DECIMAL(15,2)), 0.00),
		SUBSTRING(ev_projeto_saastizado,1,20), 
		COALESCE(CAST(NULLIF(ev_valor_recorrente, '') AS DECIMAL(15,2)), 0.00), 
		COALESCE(CAST(NULLIF(ev_valor_cdu, '') AS DECIMAL(15,2)), 0.00),
		COALESCE(CAST(NULLIF(ev_valor_proposta, '') AS DECIMAL(15,2)), 0.00)
		from zendesk_tickets_transitoria;
		
		-- Grava tabela de controle com data atualizada --
		Insert into ev_tickets_zendesk_dtatualiz (data_atualizacao, qtd_registros) 
		Values(now(), total_registros_transitoria);
  
END //
DELIMITER ;