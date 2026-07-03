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

