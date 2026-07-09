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


-- 1. MAIS USUÁRIOS (total 6 usuários agora)
INSERT INTO usuario (nome, email, senha_hash, telefone, data_cadastro) VALUES
('Carlos Souza', 'carlos.souza@email.com', '$2b$12$K3v9...', '91981112223', '2026-06-01 08:00:00'),
('Beatriz Reis', 'beatriz.reis@email.com', '$2b$12$M7x2...', '91982223334', '2026-06-03 14:30:00'),
('Thiago Silva', 'thiago.silva@email.com', '$2b$12$P1o4...', '91983334445', '2026-06-05 10:00:00'),
('Camila Santos', 'camila.santos@email.com', '$2b$12$R5t7...', '91984445556', '2026-06-07 16:20:00'),
('Rafael Oliveira', 'rafael.oliveira@email.com', '$2b$12$T8u9...', '91985556667', '2026-06-10 11:30:00'),
('Fernanda Lima', 'fernanda.lima@email.com', '$2b$12$V2w3...', '91986667778', '2026-06-12 09:45:00');

-- 2. MAIS ESTABELECIMENTOS (total 5 estabelecimentos)
INSERT INTO estabelecimento (nome_fantasia, cnpj, tipo_cozinha, taxa_frete_fixo, status, horario_abertura, horario_fechamento, data_cadastro) VALUES
('Burguer do Bairro', '12345678000101', 'Lanches', 5.00, 'aberto', '18:00:00', '23:30:00', '2026-06-01 10:00:00'),
('Pizzaria Dom Check', '98765432000102', 'Italiana', 7.50, 'aberto', '18:30:00', '23:59:00', '2026-06-02 14:00:00'),
('Sabor Caseiro', '45678912000103', 'Brasileira', 6.00, 'fechado', '11:00:00', '15:00:00', '2026-06-03 08:30:00'),
('Point do Açaí', '23456789000104', 'Cafeteria', 4.50, 'aberto', '08:00:00', '22:00:00', '2026-06-05 07:00:00'),
('Tacacá do Pará', '34567890100105', 'Regional', 8.00, 'aberto', '10:00:00', '21:00:00', '2026-06-08 09:00:00');

-- 3. MAIS ITENS DO CARDÁPIO (total 11 itens)
INSERT INTO item_cardapio (id_estabelecimento, nome, descricao, preco, disponivel) VALUES
(1, 'Smash Burguer Duplo', 'Dois blends de 90g, queijo prato, maionese artesanal e pão brioche.', 28.00, TRUE),
(1, 'Batata Frita Especial', 'Porção de 300g de batata crocante com cheddar e bacon.', 18.00, TRUE),
(1, 'Suco Natural de Maracujá', 'Copo de 400ml feito com a fruta pura.', 8.00, TRUE),
(2, 'Pizza Calabresa Grande', 'Molho de tomate, mussarela de cura, calabresa defumada e cebola.', 46.00, TRUE),
(2, 'Pizza Quatro Queijos Grande', 'Mussarela, provolone, gorgonzola marcante e catupiry original.', 52.00, TRUE),
(3, 'Menu do Dia: Executivo de Frango', 'Peito de frango grelhado, arroz, feijão preto, farofa e salada.', 22.00, TRUE),
(4, 'Açaí Médio', 'Açaí médio com granola, banana e leite condensado', 19.90, TRUE),
(4, 'Açaí Grande', 'Açaí grande com granola, banana, leite condensado e morango', 26.90, TRUE),
(4, 'Cupuaçu com Açaí', 'Cupuaçu batido com açaí e leite condensado', 22.00, TRUE),
(5, 'Tacacá', 'Tacacá tradicional com tucupi, goma e camarão', 15.00, TRUE),
(5, 'Vatapá', 'Vatapá paraense com camarão e pimenta', 20.00, TRUE);

-- 4. MAIS ENTREGADORES (total 5 entregadores)
INSERT INTO entregador (nome, cpf, telefone, veiculo, placa, status, data_cadastro) VALUES
('Marcos Motoboy', '12345678901', '91971112222', 'Moto Honda CG 160', 'ABC1D23', 'disponivel', '2026-06-01 07:00:00'),
('Lucas Ciclista', '98765432102', '91972223333', 'Bicicleta Caloi', NULL, 'offline', '2026-06-02 08:00:00'),
('André Almeida', '45678912303', '91973334444', 'Moto Yamaha Factor', 'XYZ9E87', 'ocupado', '2026-06-03 09:00:00'),
('Ronaldo Silva', '78912345604', '91974445555', 'Moto Honda Bros', 'MNO1F23', 'disponivel', '2026-06-05 10:00:00'),
('Patrícia Lima', '32165498705', '91975556666', 'Carro Fiat Uno', 'QRS4G56', 'disponivel', '2026-06-08 11:00:00');

-- 5. MAIS ENDEREÇOS (6 endereços - um para cada usuário)
INSERT INTO endereco (id_usuario, apelido, cep, logradouro, numero, complemento, bairro, cidade, estado, latitude, longitude) VALUES
(1, 'Casa', '66075110', 'Avenida Perimetral', '1000', 'Bloco B, Apto 202', 'Guamá', 'Belém', 'PA', -1.4722, -48.4542),
(2, 'Trabalho', '66055000', 'Avenida Nazaré', '450', 'Sala 10', 'Nazaré', 'Belém', 'PA', -1.4528, -48.4851),
(3, 'Apartamento', '66060000', 'Travessa Quinze de Novembro', '120', 'Apto 1104', 'Umarizal', 'Belém', 'PA', -1.4415, -48.4912),
(4, 'Casa Belém', '66045000', 'Rua Boaventura', '300', NULL, 'Marco', 'Belém', 'PA', -1.4630, -48.4720),
(5, 'Casa Ananindeua', '67045000', 'Rua das Castanheiras', '156', 'Casa 7', 'Águas Lindas', 'Ananindeua', 'PA', -1.3720, -48.3830),
(6, 'Casa Marituba', '67250000', 'Alameda dos Ingás', '89', NULL, 'Novo Marituba', 'Marituba', 'PA', -1.3600, -48.3500);

-- 6. MAIS CUPONS
INSERT INTO cupom (codigo, desconto, tipo_desconto, valor_minimo, validade, ativo) VALUES
('BEMVINDO10', 10.00, 'valor_fixo', 30.00, '2026-12-31', TRUE),
('PROMO30', 30.00, 'porcentagem', 80.00, '2026-12-31', TRUE),
('FRETEGRATIS', 6.00, 'valor_fixo', 20.00, '2026-07-31', TRUE),
('DESCONTOBEL', 15.00, 'porcentagem', 50.00, '2026-07-15', TRUE),
('CUPOM5', 5.00, 'valor_fixo', 25.00, '2026-08-31', TRUE);

-- 7. MAIS PEDIDOS (total 15 pedidos com alguns cancelados)
-- Pedido 1 (já existente)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(1, 1, 1, 'entregue', 54.00, 0.00, '2026-06-02 19:15:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(1, 1, 1, 28.00),
(1, 2, 1, 18.00);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(1, 1, 'entregue', 25, '2026-06-02 19:20:00', '2026-06-02 19:45:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(1, 'pix', 54.00, 'aprovado', '2026-06-02 19:18:00', 1);

INSERT INTO pedido_cupom (id_pedido, id_cupom) VALUES
(1, 3);

-- Pedido 2 (já existente)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(2, 2, 2, 'preparando', 98.00, 0.00, '2026-06-04 20:00:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(2, 4, 1, 46.00),
(2, 5, 1, 52.00);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(2, 3, 'coletando', 35, '2026-06-04 20:05:00', NULL);

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(2, 'cartao_credito', 98.00, 'aprovado', '2026-06-04 20:02:00', 2);

-- Pedido 3 (já existente)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(3, 1, 3, 'aguardando_pagamento', 28.00, 0.00, '2026-06-06 18:30:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(3, 1, 1, 28.00);

-- Pedido 4 (NOVO - Cancelado)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(4, 4, 4, 'cancelado', 26.90, 0.00, '2026-06-08 15:30:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(4, 8, 1, 26.90);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(4, 4, 'cancelada', 20, '2026-06-08 15:35:00', '2026-06-08 15:40:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(4, 'dinheiro', 26.90, 'recusado', '2026-06-08 15:32:00', 3);

-- Pedido 5 (NOVO - Entregue)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(5, 5, 5, 'entregue', 43.00, 0.00, '2026-06-10 12:00:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(5, 10, 1, 15.00),
(5, 11, 1, 20.00);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(5, 4, 'entregue', 30, '2026-06-10 12:05:00', '2026-06-10 12:35:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(5, 'pix', 43.00, 'aprovado', '2026-06-10 12:02:00', 4);

-- Pedido 6 (NOVO - Cancelado)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(6, 4, 6, 'cancelado', 41.90, 0.00, '2026-06-12 16:00:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(6, 7, 1, 19.90),
(6, 9, 1, 22.00);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(6, 5, 'cancelada', 25, '2026-06-12 16:05:00', '2026-06-12 16:10:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(6, 'cartao_credito', 41.90, 'recusado', '2026-06-12 16:02:00', 5);

-- Pedido 7 (NOVO - Entregue)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(1, 3, 1, 'entregue', 22.00, 0.00, '2026-06-14 11:30:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(7, 6, 1, 22.00);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(7, 4, 'entregue', 20, '2026-06-14 11:35:00', '2026-06-14 11:55:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(7, 'vale_refeicao', 22.00, 'aprovado', '2026-06-14 11:32:00', 6);

-- Pedido 8 (NOVO - Cancelado)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(2, 5, 2, 'cancelado', 20.00, 0.00, '2026-06-16 13:00:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(8, 11, 1, 20.00);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(8, 5, 'cancelada', 25, '2026-06-16 13:05:00', '2026-06-16 13:10:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(8, 'pix', 20.00, 'pendente', '2026-06-16 13:02:00', 7);

-- Pedido 9 (NOVO - Entregue)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(3, 2, 3, 'entregue', 52.00, 0.00, '2026-06-18 21:00:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(9, 5, 1, 52.00);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(9, 3, 'entregue', 30, '2026-06-18 21:05:00', '2026-06-18 21:35:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(9, 'cartao_credito', 52.00, 'aprovado', '2026-06-18 21:02:00', 8);

-- Pedido 10 (NOVO - Cancelado)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(4, 1, 4, 'cancelado', 36.00, 0.00, '2026-06-20 19:30:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(10, 1, 1, 28.00),
(10, 3, 1, 8.00);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(10, 1, 'cancelada', 20, '2026-06-20 19:35:00', '2026-06-20 19:40:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(10, 'cartao_debito', 36.00, 'recusado', '2026-06-20 19:32:00', 9);

-- Pedido 11 (NOVO - Entregue)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(5, 4, 5, 'entregue', 48.80, 10.00, '2026-06-22 17:00:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(11, 7, 1, 19.90),
(11, 9, 1, 22.00);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(11, 4, 'entregue', 25, '2026-06-22 17:05:00', '2026-06-22 17:30:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(11, 'pix', 48.80, 'aprovado', '2026-06-22 17:02:00', 10);

INSERT INTO pedido_cupom (id_pedido, id_cupom) VALUES
(11, 4);

-- Pedido 12 (NOVO - Entregue)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(6, 2, 6, 'entregue', 46.00, 0.00, '2026-06-24 20:30:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(12, 4, 1, 46.00);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(12, 2, 'entregue', 35, '2026-06-24 20:35:00', '2026-06-24 21:10:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(12, 'cartao_credito', 46.00, 'aprovado', '2026-06-24 20:32:00', 11);

-- Pedido 13 (NOVO - Cancelado)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(1, 5, 1, 'cancelado', 15.00, 0.00, '2026-06-26 11:00:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(13, 10, 1, 15.00);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(13, 5, 'cancelada', 20, '2026-06-26 11:05:00', '2026-06-26 11:10:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(13, 'dinheiro', 15.00, 'pendente', '2026-06-26 11:02:00', 12);

-- Pedido 14 (NOVO - Entregue)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(2, 4, 2, 'entregue', 26.90, 0.00, '2026-06-28 16:30:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(14, 8, 1, 26.90);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(14, 1, 'entregue', 15, '2026-06-28 16:35:00', '2026-06-28 16:50:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(14, 'pix', 26.90, 'aprovado', '2026-06-28 16:32:00', 13);

-- Pedido 15 (NOVO - Cancelado)
INSERT INTO pedido (id_usuario, id_estabelecimento, id_endereco, status, valor_total, desconto_aplicado, data_pedido) VALUES
(3, 3, 3, 'cancelado', 22.00, 0.00, '2026-06-30 12:00:00');

INSERT INTO pedido_item (id_pedido, id_item, quantidade, preco_unitario) VALUES
(15, 6, 1, 22.00);

INSERT INTO entrega (id_pedido, id_entregador, status, tempo_estimado, data_inicio, data_fim) VALUES
(15, 2, 'cancelada', 20, '2026-06-30 12:05:00', '2026-06-30 12:10:00');

INSERT INTO pagamento (id_pedido, metodo, valor, status, data_processamento, id_entrega) VALUES
(15, 'cartao_credito', 22.00, 'recusado', '2026-06-30 12:02:00', 14);

-- 8. MAIS AVALIAÇÕES (total 8 avaliações)
INSERT INTO avaliacao (id_pedido, id_usuario, id_estabelecimento, nota, comentario, data_avaliacao) VALUES
(1, 1, 1, 5, 'O hambúrguer estava incrível, muito suculento! Chegou antes do tempo previsto.', '2026-06-03 10:00:00'),
(5, 5, 5, 4, 'Tacacá muito bom, mas demorou um pouco para entregar.', '2026-06-11 14:00:00'),
(7, 1, 3, 3, 'Comida ok, mas o restaurante estava fechado no dia seguinte.', '2026-06-15 09:00:00'),
(9, 3, 2, 5, 'Pizza deliciosa, entrega super rápida!', '2026-06-19 10:00:00'),
(11, 5, 4, 5, 'Açaí maravilhoso, recomendo o cupuaçu com açaí!', '2026-06-23 09:30:00'),
(12, 6, 2, 4, 'Pizza boa, mas faltou um pouco mais de queijo.', '2026-06-25 11:00:00'),
(14, 2, 4, 5, 'Açaí grande muito bom, veio bem servido!', '2026-06-29 10:00:00');

-- 9. MAIS HORÁRIOS ESPECIAIS
INSERT INTO horario_especial (id_estabelecimento, data_especial, horario_abertura, horario_fechamento, descricao) VALUES
(1, '2026-12-25', NULL, NULL, 'Natal - Fechado'),
(2, '2026-12-31', '18:00:00', '22:00:00', 'Véspera de Ano Novo - Horário Reduzido'),
(4, '2026-06-24', '08:00:00', '14:00:00', 'Feriado de São João - Funcionamento até 14h'),
(5, '2026-06-24', '10:00:00', '15:00:00', 'Feriado de São João - Funcionamento especial');
