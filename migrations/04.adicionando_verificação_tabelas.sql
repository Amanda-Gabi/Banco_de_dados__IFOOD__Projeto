ALTER TABLE usuario 
    ADD CONSTRAINT check_telefone_usuario 
    CHECK (telefone IS NULL OR telefone ~ '^[0-9]+$');

ALTER TABLE estabelecimento 
    ADD CONSTRAINT check_cnpj_numeros 
    CHECK (cnpj ~ '^[0-9]{14}$');

ALTER TABLE entregador 
    ADD CONSTRAINT check_cpf_numeros CHECK (cpf ~ '^[0-9]{11}$'),
    ADD CONSTRAINT check_telefone_entregador CHECK (telefone IS NULL OR telefone ~ '^[0-9]+$'), 
    ADD CONSTRAINT check_placa_numeros_letras CHECK (placa IS NULL OR placa ~ '^[A-Z0-9]+$');

ALTER TABLE endereco 
    ADD CONSTRAINT check_cep_numeros 
    CHECK (cep ~ '^[0-9]{8}$');
