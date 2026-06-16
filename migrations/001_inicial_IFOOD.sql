CREATE TABLE usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    telefone VARCHAR(15),
    endereco_padrao TEXT NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE estabelecimento (
    id_estabelecimento INT PRIMARY KEY AUTO_INCREMENT,
    nome_fantasia VARCHAR(100) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    tipo_cozinha VARCHAR(50),
    endereco TEXT NOT NULL,
    horario_abertura TIME,
    horario_fechamento TIME,
    taxa_frete_fixo DECIMAL(5,2) DEFAULT 0.00,
    status ENUM('aberto','fechado','pausado') DEFAULT 'fechado',
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE item_cardapio (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_estabelecimento INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(8,2) NOT NULL CHECK (preco > 0),
    imagem_url VARCHAR(255),
    disponivel BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_estabelecimento) 
        REFERENCES estabelecimento(id_estabelecimento)
        ON DELETE CASCADE
);
