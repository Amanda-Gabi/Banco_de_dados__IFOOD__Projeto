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
