# Projeto Final - ORM PostgreSQL

## Como executar

1. Instalar dependências:
pip install sqlalchemy psycopg2-binary

2. Configurar conexão no arquivo database.py

3. Executar:
python main.py

## Funcionalidades

- CRUD completo com ORM
- Consultas com JOIN
- Filtros e ordenação

## Banco de dados

O arquivo banco.sql contém toda a estrutura do banco de dados,
incluindo tabelas, inserts, constraints, views, triggers e procedures.

Para recriar o banco:

1. Criar um banco no PostgreSQL
2. Executar o script banco.sql no pgAdmin ou psql

## Evidências

Executar o arquivo main.py e observar a saída no terminal.