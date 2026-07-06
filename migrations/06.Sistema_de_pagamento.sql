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
