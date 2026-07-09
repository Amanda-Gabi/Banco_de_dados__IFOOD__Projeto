CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    telefone VARCHAR(15),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE estabelecimento (
    id_estabelecimento SERIAL PRIMARY KEY,
    nome_fantasia VARCHAR(100) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    tipo_cozinha VARCHAR(50),
    taxa_frete_fixo DECIMAL(8,2) DEFAULT 0.00,
    status VARCHAR(20) CHECK (status IN ('aberto','fechado','pausado')) DEFAULT 'fechado',
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE item_cardapio (
    id_item SERIAL PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(8,2) NOT NULL CHECK (preco > 0),
    disponivel BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_estabelecimento) 
        REFERENCES estabelecimento(id_estabelecimento)
        ON DELETE CASCADE
);


CREATE TABLE entregador (
    id_entregador SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    veiculo VARCHAR(50),
    placa VARCHAR(10),
    status VARCHAR(20) CHECK (status IN ('disponivel','ocupado','offline')) DEFAULT 'offline',
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE endereco (
    id_endereco SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    apelido VARCHAR(50),
    cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    FOREIGN KEY (id_usuario) 
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);


CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_estabelecimento INT NOT NULL,
    id_endereco INT NOT NULL,
    status VARCHAR(25) CHECK (status IN ('aguardando_pagamento','pendente','confirmado','preparando','saiu_entrega','entregue','cancelado')) DEFAULT 'aguardando_pagamento',
    valor_total DECIMAL(10,2) NOT NULL CHECK (valor_total >= 0.00),
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_estabelecimento) REFERENCES estabelecimento(id_estabelecimento),
    FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco)
);


CREATE TABLE pedido_item (
    id_pedido_item SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_item INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1 CHECK (quantidade > 0),
    preco_unitario DECIMAL(8,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_item) REFERENCES item_cardapio(id_item)
);


ALTER TABLE endereco 
    ADD COLUMN latitude DECIMAL(10,8),
    ADD COLUMN longitude DECIMAL(11,8);

ALTER TABLE estabelecimento 
    ADD COLUMN horario_abertura TIME,
    ADD COLUMN horario_fechamento TIME;

CREATE TABLE horario_especial (
    id_horario SERIAL PRIMARY KEY,
    id_estabelecimento INT NOT NULL,
    data_especial DATE NOT NULL,
    horario_abertura TIME,
    horario_fechamento TIME,
    descricao VARCHAR(100),
    
    FOREIGN KEY (id_estabelecimento) 
        REFERENCES estabelecimento(id_estabelecimento)
);


CREATE TABLE avaliacao (
    id_avaliacao SERIAL PRIMARY KEY,
    id_pedido INT UNIQUE NOT NULL,
    id_usuario INT NOT NULL,
    id_estabelecimento INT NOT NULL,
    nota INT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario VARCHAR(255),
    data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_estabelecimento) REFERENCES estabelecimento(id_estabelecimento)
);


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

ALTER TABLE pedido 
    ADD COLUMN desconto_aplicado DECIMAL(10,2) DEFAULT 0.00;

CREATE TABLE entrega (
    id_entrega SERIAL PRIMARY KEY,
    id_pedido INT UNIQUE NOT NULL,
    id_entregador INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pendente','coletando','em_rota','entregue','cancelada')) DEFAULT 'pendente',
    tempo_estimado INT,
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_entregador) REFERENCES entregador(id_entregador)
);


CREATE TABLE pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    id_pedido INT UNIQUE NOT NULL,
    metodo VARCHAR(30) CHECK (metodo IN ('cartao_credito','cartao_debito','pix','dinheiro','vale_refeicao')),
    valor DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pendente','aprovado','recusado','estornado')),
    data_processamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);

CREATE TABLE cupom (
    id_cupom SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    desconto DECIMAL(5,2) NOT NULL,
    tipo_desconto VARCHAR(20) CHECK (tipo_desconto IN ('porcentagem','valor_fixo')),
    valor_minimo DECIMAL(10,2) DEFAULT 0.00,
    validade DATE,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE pedido_cupom (
    id_pedido INT NOT NULL,
    id_cupom INT NOT NULL,
    PRIMARY KEY (id_pedido, id_cupom),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_cupom) REFERENCES cupom(id_cupom)
);


ALTER TABLE pagamento 
    ADD COLUMN id_entrega INT UNIQUE,
    ADD CONSTRAINT fk_pagamento_entrega 
    FOREIGN KEY (id_entrega) REFERENCES entrega(id_entrega);


CREATE INDEX idx_usuario_email ON usuario(email);
CREATE INDEX idx_estab_cnpj ON estabelecimento(cnpj);
CREATE INDEX idx_estab_status ON estabelecimento(status);
CREATE INDEX idx_pedido_usuario ON pedido(id_usuario);
CREATE INDEX idx_pedido_status ON pedido(status);
CREATE INDEX idx_pedido_data ON pedido(data_pedido);
CREATE INDEX idx_item_cardapio_estab ON item_cardapio(id_estabelecimento);
CREATE INDEX idx_entregador_status ON entregador(status);
CREATE INDEX idx_endereco_cep ON endereco(cep);
CREATE INDEX idx_avaliacao_estabelecimento ON avaliacao(id_estabelecimento);
CREATE INDEX idx_entrega_status ON entrega(status);


-- 1. Povoar Usuários
INSERT INTO usuario (nome, email, senha_hash, telefone) VALUES
('Carlos Souza', 'carlos.souza@email.com', '$2b$12$K3v9...', '91981112223'),
('Beatriz Reis', 'beatriz.reis@email.com', '$2b$12$M7x2...', '91982223334'),
('Thiago Silva', 'thiago.silva@email.com', '$2b$12$P1o4...', '91983334445');

-- 2. Povoar Estabelecimentos (CNPJ com 14 dígitos exatos)
INSERT INTO estabelecimento (nome_fantasia, cnpj, tipo_cozinha, taxa_frete_fixo, status, horario_abertura, horario_fechamento) VALUES
('Burguer do Bairro', '12345678000101', 'Lanches', 5.00, 'aberto', '18:00:00', '23:30:00'),
('Pizzaria Dom Check', '98765432000102', 'Italiana', 7.50, 'aberto', '18:30:00', '23:59:00'),
('Sabor Caseiro', '45678912000103', 'Brasileira', 6.00, 'fechado', '11:00:00', '15:00:00');

-- 3. Povoar Itens do Cardápio
INSERT INTO item_cardapio (id_estabelecimento, nome, descricao, preco, disponivel) VALUES
(1, 'Smash Burguer Duplo', 'Dois blends de 90g, queijo prato, maionese artesanal e pão brioche.', 28.00, TRUE),
(1, 'Batata Frita Especial', 'Porção de 300g de batata crocante com cheddar e bacon.', 18.00, TRUE),
(1, 'Suco Natural de Maracujá', 'Copo de 400ml feito com a fruta pura.', 8.00, TRUE),
(2, 'Pizza Calabresa Grande', 'Molho de tomate, mussarela de cura, calabresa defumada e cebola.', 46.00, TRUE),
(2, 'Pizza Quatro Queijos Grande', 'Mussarela, provolone, gorgonzola marcante e catupiry original.', 52.00, TRUE),
(3, 'Menu do Dia: Executivo de Frango', 'Peito de frango grelhado, arroz, feijão preto, farofa e salada.', 22.00, TRUE);

-- 4. Povoar Entregadores (CPF com 11 dígitos, Placa sem hifens)
INSERT INTO entregador (nome, cpf, telefone, veiculo, placa, status) VALUES
('Marcos Motoboy', '12345678901', '91971112222', 'Moto Honda CG 160', 'ABC1D23', 'disponivel'),
('Lucas Ciclista', '98765432102', '91972223333', 'Bicicleta Caloi', NULL, 'offline'),
('André Almeida', '45678912303', '91973334444', 'Moto Yamaha Factor', 'XYZ9E87', 'ocupado');

-- 5. Povoar Endereços (CEP com 8 dígitos exatos)
INSERT INTO endereco (id_usuario, apelido, cep, logradouro, numero, complemento, bairro, cidade, estado, latitude, longitude) VALUES
(1, 'Casa', '66075110', 'Avenida Perimetral', '1000', 'Bloco B, Apto 202', 'Guamá', 'Belém', 'PA', -1.4722, -48.4542),
(2, 'Trabalho', '66055000', 'Avenida Nazaré', '450', 'Sala 10', 'Nazaré', 'Belém', 'PA', -1.4528, -48.4851),
(3, 'Apartamento', '66060000', 'Travessa Quinze de Novembro', '120', 'Apto 1104', 'Umarizal', 'Belém', 'PA', -1.4415, -48.4912);

-- 6. Povoar Cupons
INSERT INTO cupom (codigo, desconto, tipo_desconto, valor_minimo, validade, ativo) VALUES
('BEMVINDO10', 10.00, 'valor_fixo', 30.00, '2026-12-31', TRUE),
('PROMO30', 30.00, 'porcentagem', 80.00, '2026-12-31', TRUE),
('FRETEGRATIS', 6.00, 'valor_fixo', 20.00, '2026-07-31', TRUE);

-- 7. Povoar Pedidos (O valor total deve ser fornecido manualmente de acordo com a restrição NOT NULL)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado) VALUES
(1, 1, 1, 'entregue', 54.00, 0.00),     -- Pedido 1 concluído (Subtotal itens 46.00 + Frete 5.00 + 3.00 gorjeta opcional)
(2, 2, 2, 'preparando', 98.00, 0.00),   -- Pedido 2 em andamento
(3, 1, 3, 'aguardando_pagamento', 28.00, 0.00); -- Pedido 3 novo

-- 8. Povoar Itens dos Pedidos (A coluna subtotal é calculada e armazenada automaticamente pelo banco)
INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(1, 1, 1, 28.00), -- 1 Smash Burguer para o Pedido 1
(1, 2, 1, 18.00), -- 1 Batata Frita para o Pedido 1
(2, 4, 1, 46.00), -- 1 Pizza Calabresa para o Pedido 2
(2, 5, 1, 52.00), -- 1 Pizza Quatro Queijos para o Pedido 2
(3, 1, 1, 28.00); -- 1 Smash Burguer para o Pedido 3

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(1, 1, 'entregue', 25, '2026-07-08 19:15:00', '2026-07-08 19:40:00'),
(2, 3, 'coletando', 35, '2026-07-08 20:00:00', NULL);

-- 10. Povoar Pagamentos (Agora que as entregas existem, vinculamos os IDs correspondentes)
INSERT INTO pagamento (id_pedido, metodo, valor, status, id_entrega) VALUES
(1, 'pix', 54.00, 'aprovado', 1),
(2, 'cartao_credito', 98.00, 'aprovado', 2);

-- 11. Povoar Horários Especiais
INSERT INTO horario_especial (id_estabelecimento, data_especial, horario_abertura, horario_fechamento, descricao) VALUES
(1, '2026-12-25', NULL, NULL, 'Natal - Fechado'),
(2, '2026-12-31', '18:00:00', '22:00:00', 'Véspera de Ano Novo - Horário Reduzido');

-- 12. Povoar Avaliações
INSERT INTO avaliacao (id_pedido, id_usuario, id_estabelecimento, nota, comentario) VALUES
(1, 1, 1, 5, 'O hambúrguer estava incrível, muito suculento! Chegou antes do tempo previsto.');

-- 13. Povoar Pedido_Cupom (Associação do cupom utilizado no pedido, se aplicável)
INSERT INTO pedido_cupom (id_pedido, id_cupom) VALUES
(1, 3); -- Pedido 1 utilizou o cupom FRETEGRATIS
