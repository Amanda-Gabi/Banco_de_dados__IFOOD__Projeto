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
