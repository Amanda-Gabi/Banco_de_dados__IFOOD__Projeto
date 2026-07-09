-- ============================================
-- CONTINUAÇÃO DO POVOAMENTO
-- ADICIONANDO MAIS DADOS PARA BELÉM E REGIÃO
-- ============================================

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
