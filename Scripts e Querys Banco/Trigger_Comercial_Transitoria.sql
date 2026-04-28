-- Julio Cesar Guerato / Abril - 2026 --
-- Dispara a TRIGGER logo que a tabela oportunidades_processamento_work for preenchida  --
-- Tabela é populado pelo extracaoclientestenant.py que roda no CAROL APPS diariamente  --
-- Assim que termina o processamento o CAROL APPS a TRIGGER deverá ser disparada        --
-- A TRIGGER fará o processamento em cima da tabela OPORTUNIDADES_TENANT e irá gravar   --
-- a tabela OPORTUNIDADES_TRANSITORIA e ao final, poupar a tabela EV_OPORTUNIDADES      --
-- que é a tabela ofical para indicadores                                               --
DELIMITER //
CREATE TRIGGER trigger_comercial_transitoria
AFTER INSERT ON oportunidades_processamento_work
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
		
        INSERT INTO oportunidades_processamento_erros (data_processamento, codigo_erro, mensagem_erro)
        VALUES (now() , erro_codigo, erro_texto);
	END;
    
    -- Reseta e ajusta hora horario Brasil --
    SET time_zone = '-03:00';
    SET SQL_SAFE_UPDATES = 0;
    
    -- Quantidade de registros da tabela OPORTUNIDADES_tenant --
    -- Tabela original vinda da Tenant e carregada via Script --
    SELECT COUNT(*) INTO total_registros_tenant FROM oportunidades_tenant;
    
    -- Limpa a tabela oportunidades em tabela de trabalho - oportunidades_transitoria --
    delete from oportunidades_transitoria where 1=1;
    
    -- Insere oportunidades capturados da tenant para oportunidades_transitoria --
    -- Campos após o Select *, se referem a campos calculados
    INSERT INTO oportunidades_transitoria
    select *,0,0,0,'' from oportunidades_tenant;
    
    -- Elimina as oportunidades que não forem do time de Eng de Valor, conforme a tabela EV_TIME --
    DELETE FROM oportunidades_transitoria
     WHERE NOT EXISTS (
           SELECT 1 
             FROM ev_time
            WHERE trim(ev_time.nome) = trim(oportunidades_transitoria.nome_ev)
     );
     
     -- Atualiza o campo equipe_fasttrack, considerando propostas que sejam do time FAST --
	 UPDATE oportunidades_transitoria, ev_time
	    SET oportunidades_transitoria.equipe_fasttrack = 'SIM'
	  WHERE trim(oportunidades_transitoria.nome_ev) = trim(ev_time.nome)
	    AND oportunidades_transitoria.data_inclusao >= ev_time.data_entrada_fasttrack
	    AND (oportunidades_transitoria.data_inclusao <= ev_time.data_saida_fasttrack OR ev_time.data_saida_fasttrack IS NULL);
      
	-- Ajustes diversos na tabela transitoria --
    
    -- SERVIÇOS --
    -- Calcula o percentual referente a cada 
	UPDATE oportunidades_transitoria
	   SET valor_servicos_part = round((valor_servicos * particip)/100,2)
	WHERE valor_servicos<>0 and particip<>0;
    
    UPDATE oportunidades_transitoria
	   SET valor_servicos_part = 0 
	WHERE valor_servicos = 0;

	-- Recorrentes --
    UPDATE oportunidades_transitoria
	   SET valor_recorrentes_part = round((valor_recorrentes * particip)/100,2)
	WHERE valor_recorrentes<>0 and particip<>0;
    
    UPDATE oportunidades_transitoria
	   SET valor_recorrentes_part = 0 
	WHERE valor_recorrentes = 0;
    
    -- CDU --
    UPDATE oportunidades_transitoria
	   SET valor_cdu_part = round((valor_cdu * particip)/100,2)
	WHERE valor_cdu<>0 and particip<>0;
    
    UPDATE oportunidades_transitoria
	   SET valor_cdu_part = 0 
	WHERE valor_cdu = 0; 
	       
    -- Total de registros da tabela Transitoria --
    SELECT COUNT(*) INTO total_registros_transitoria FROM oportunidades_transitoria;
    
    -- Limpa a Tabela de data de atualização --
	Delete from ev_oportunidades_dtatualiz Where 1=1;
    
	-- Limpa a Tabela oportunidades Oficial - base para Locker --
	Delete from ev_oportunidades Where 1=1;
	  
	-- INSERE OS REGISTROS NA TABELA EV_OPORTUNIDADES OFICIAL DA ENG DE VALOR -------
	insert into ev_oportunidades
	select *
	  from oportunidades_transitoria;
        
	-- Grava tabela de controle com data atualizada --
	insert into ev_oportunidades_dtatualiz (data_atualizacao, qtd_registros) 
	values(now(), total_registros_transitoria);
  
END //
DELIMITER ;