# Modelagem de banco de dados do iFood - Projeto de Disciplina
O iFood é o maior aplicativo de delivery de comida do Brasil. Através dele,o usuário faz pedidos 
em restaurantes parceiros cadastrados na plataforma, que são preparados e entregues no endereço escolhido. 
Fundado em 2011 e pertencente ao grupo Movile, o iFood conecta milhões de clientes a uma enorme 
variedade de restaurantes, desde lanchonetes locais até grandes redes,
com opções que vão da comida caseira à alta gastronomia.

# Sobre o Projeto
Este repositório contém a modelagem do banco de dados do aplicativo **iFood**, desenvolvida para o projeto final da disciplina **Banco de Dados I**, ministrada no período 2026.2 na **Faculdade de Computação (FACOMP)** da **Universidade Federal do Pará (UFPA)**.

# Ferramentas utilizadas
- **Supabase**: escrita e testes do SQL do banco de dados (PostgreSQL)
- **Git e GitHub**: controle e versionamento dos códigos SQL da modelagem

# Discentes
- Amanda Gabriella S. B. do Nascimento - 202411140035
- Anderson Silva - 
- Renata Galvão da Silva - 202311140050


# Estrutura do Projeto
```text
Banco_de_dados__IFOOD__Projeto/
│
├── images/
│   ├── logo_ifood.png
│
├── migrations/
│   ├── 001_inicial_IFOOD.sql
│   ├── 02_sistema_pedidos.sql
│   ├── 03_criando_geolocalizacao_e_avaliacao.sql
│   ├── 04_adicionando_verificacao_tabelas.sql
│   ├── 05_preenchendo_lacunas.sql
│   ├── ...
|
├── README.md
└── database.sql

```

# Como executar as migrações
1. Abra o arquivo `database.sql` que está na raiz do projeto
2. Copie todo o conteúdo
3. Acesse o [Supabase](https://supabase.com)
4. Crie um novo projeto
5. No menu lateral, clique em **SQL Editor**
6. Clique em **New query**
7. Cole o conteúdo copiado
8. Clique em Run
   
> ⚠️ O arquivo `database.sql` já contém todas as migrações na ordem correta. Basta executar uma única vez!


