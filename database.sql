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
