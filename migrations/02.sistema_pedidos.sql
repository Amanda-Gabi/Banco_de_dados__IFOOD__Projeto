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
