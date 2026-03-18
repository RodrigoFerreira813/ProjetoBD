-- UNIVERSIDADE FEDERAL DO CARIRI - UFCA
-- PRÓ-REITORIA DE GRADUAÇÃO - PROGRAD
-- CENTRO DE EDUCAÇÃO À DISTÂNCIA - CEAD
-- CURSO DE ANALISE E DESENVOLVIMENTO DE SISTEMAS
-- Disciplina: ADS0011- PROJETO DE BANCO DE DADOS (2025.2)
-- Aluno: Carlos Rodrigo Ferreira da Silva
-- Matrícula: 2025014304
-- TEMA 7 – SISTEMA DE QUIZ EDUCACIONAL

CREATE TABLE "Usuario" (
    "id" int   NOT NULL,
    "nome" varchar(100)   NOT NULL,
    "email" varchar(100)   NOT NULL,
    "matricula" varchar(50)   NOT NULL,
    "time_stamp" timestamp   NOT NULL,
    CONSTRAINT "pk_Usuario" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_Usuario_email" UNIQUE (
        "email"
    ),
    CONSTRAINT "uc_Usuario_matricula" UNIQUE (
        "matricula"
    )
);


CREATE TYPE nivel_dificuldade_enum AS ENUM (
    'FACIL',
    'MEDIO',
    'DIFICIL'
);

CREATE TABLE "Pergunta" (
    "id" int NOT NULL,
    "enunciado" text NOT NULL,
    "tema" varchar(100) NOT NULL,
    "nivel_dificuldade" nivel_dificuldade_enum NOT NULL,
    "peso" int NOT NULL,
    "alternativas_json" text NOT NULL,
    "indice_correta" int NOT NULL,
    "time_stamp" timestamp NOT NULL,
    CONSTRAINT "pk_Pergunta" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Quiz" (
    "id" int   NOT NULL,
    "titulo" varchar(100)   NOT NULL,
    "tempo_limite_min" int   NOT NULL,
    "max_tentativas" int   NOT NULL,
    "pontuacao_maxima" int   NOT NULL,
    "time_stamp" timestamp   NOT NULL,
    CONSTRAINT "pk_Quiz" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Quiz_Pergunta" (
    "id" int   NOT NULL,
    "id_quiz" int   NOT NULL,
    "id_pergunta" int   NOT NULL,
    "time_stamp" timestamp   NOT NULL,
    CONSTRAINT "pk_Quiz_Pergunta" PRIMARY KEY (
        "id","id_pergunta"
     )
);

CREATE TABLE "Tentativa" (
    "id" int   NOT NULL,
    "id_usuario" int   NOT NULL,
    "id_quiz" int   NOT NULL,
    "pontuacao_obtida" int   NOT NULL,
    "total_acertos" int   NOT NULL,
    "tempo_gasto_seg" int   NOT NULL,
    "finalizada" boolean   NOT NULL,
    "time_stamp" timestamp   NOT NULL,
    CONSTRAINT "pk_Tentativa" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "Quiz_Pergunta" ADD CONSTRAINT "fk_Quiz_Pergunta_id_quiz" FOREIGN KEY("id_quiz")
REFERENCES "Quiz" ("id");

ALTER TABLE "Quiz_Pergunta" ADD CONSTRAINT "fk_Quiz_Pergunta_id_pergunta" FOREIGN KEY("id_pergunta")
REFERENCES "Pergunta" ("id");

ALTER TABLE "Tentativa" ADD CONSTRAINT "fk_Tentativa_id_usuario" FOREIGN KEY("id_usuario")
REFERENCES "Usuario" ("id");

ALTER TABLE "Tentativa" ADD CONSTRAINT "fk_Tentativa_id_quiz" FOREIGN KEY("id_quiz")
REFERENCES "Quiz" ("id");

-- ===============================
-- ETAPA 3 - PROJETO FINAL
-- Carga de dados (INSERTs)
-- ===============================

-- Usuários
INSERT INTO "Usuario" VALUES
(1, 'Ana Silva', 'ana@email.com', 'MAT001', NOW()),
(2, 'Bruno Costa', 'bruno@email.com', 'MAT002', NOW()),
(3, 'Carlos Lima', 'carlos@email.com', 'MAT003', NOW());

-- Perguntas
INSERT INTO "Pergunta" VALUES
(1, 'O que é um JOIN em SQL?', 'Banco de Dados', 'FACIL', 10, '{"A":"Comando de seleção","B":"Relaciona tabelas","C":"Cria tabela"}', 2, NOW()),
(2, 'O que é uma chave primária?', 'Banco de Dados', 'MEDIO', 15, '{"A":"Identificador único","B":"Campo opcional","C":"Índice"}', 1, NOW()),
(3, 'Para que serve LEFT JOIN?', 'Banco de Dados', 'DIFICIL', 20, '{"A":"Une apenas iguais","B":"Retorna todos da esquerda","C":"Exclui nulos"}', 2, NOW());

-- Quizzes
INSERT INTO "Quiz" VALUES
(1, 'Quiz SQL Básico', 20, 3, 100, NOW()),
(2, 'Quiz Modelagem', 30, 2, 150, NOW()),
(3, 'Quiz Avançado SQL', 40, 1, 200, NOW());

-- Associação Quiz x Pergunta
INSERT INTO "Quiz_Pergunta" VALUES
(1, 1, 1, NOW()),
(2, 1, 2, NOW()),
(3, 2, 2, NOW()),
(4, 2, 3, NOW()),
(5, 3, 3, NOW());

-- Tentativas
INSERT INTO "Tentativa" VALUES
(1, 1, 1, 80, 2, 600, TRUE, NOW()),
(2, 2, 1, 60, 1, 900, TRUE, NOW()),
(3, 1, 2, 120, 2, 1200, FALSE, NOW());

-- ===============================
-- Consultas (SELECT)
-- ===============================

-- Consulta 1:
-- Objetivo: Exibir todas as tentativas realizadas, mostrando o nome do usuário,
-- o título do quiz associado e a pontuação obtida em cada tentativa.
SELECT 
    t.id AS tentativa_id,
    u.nome AS usuario,
    q.titulo AS quiz,
    t.pontuacao_obtida
FROM "Tentativa" t
JOIN "Usuario" u ON t.id_usuario = u.id
JOIN "Quiz" q ON t.id_quiz = q.id;

-- Consulta 2:
-- Objetivo: Listar todas as perguntas vinculadas a cada quiz,
-- apresentando o título do quiz, o enunciado da pergunta
-- e o nível de dificuldade.
SELECT
    q.titulo AS quiz,
    p.enunciado AS pergunta,
    p.nivel_dificuldade
FROM "Quiz_Pergunta" qp
JOIN "Quiz" q ON qp.id_quiz = q.id
JOIN "Pergunta" p ON qp.id_pergunta = p.id;

-- Consulta 3:
-- Objetivo: Recuperar apenas as tentativas que já foram finalizadas,
-- exibindo o nome do usuário, o quiz realizado e a pontuação obtida.
SELECT
    u.nome,
    q.titulo,
    t.pontuacao_obtida
FROM "Tentativa" t
JOIN "Usuario" u ON t.id_usuario = u.id
JOIN "Quiz" q ON t.id_quiz = q.id
WHERE t.finalizada = TRUE;

-- Consulta 4:
-- Objetivo: Listar todos os usuários do sistema, incluindo aqueles
-- que ainda não realizaram nenhuma tentativa, utilizando LEFT JOIN.
SELECT
    u.nome,
    t.id AS tentativa_id,
    t.pontuacao_obtida
FROM "Usuario" u
LEFT JOIN "Tentativa" t ON u.id = t.id_usuario;

-- Consulta 5:
-- Objetivo: Selecionar todas as perguntas classificadas com nível
-- de dificuldade DIFÍCIL, exibindo seu enunciado, tema e peso.
SELECT
    enunciado,
    tema,
    peso
FROM "Pergunta"
WHERE nivel_dificuldade = 'DIFICIL';

-- =====================================================
-- [Projeto Final] — Etapa 4: Constraints e Integridade
-- =====================================================

-- -----------------------------------------------------
-- 1) CHECK CONSTRAINTS
-- -----------------------------------------------------

-- CHECK para impedir que a pontuação obtida seja negativa
ALTER TABLE "Tentativa"
ADD CONSTRAINT ck_tentativa_pontuacao_positiva
CHECK (pontuacao_obtida >= 0);

-- CHECK para garantir que o tempo limite do quiz seja maior que zero
ALTER TABLE "Quiz"
ADD CONSTRAINT ck_quiz_tempo_limite_valido
CHECK (tempo_limite_min > 0);

-- CHECK para impedir peso negativo em perguntas
ALTER TABLE "Pergunta"
ADD CONSTRAINT ck_pergunta_peso_valido
CHECK (peso > 0);

-- -----------------------------------------------------
-- 2) UNIQUE CONSTRAINT ADICIONAL
-- -----------------------------------------------------

-- UNIQUE para impedir que dois quizzes tenham o mesmo título
ALTER TABLE "Quiz"
ADD CONSTRAINT uc_quiz_titulo UNIQUE (titulo);

-- -----------------------------------------------------
-- 3) DEFAULT VALUES
-- -----------------------------------------------------

-- DEFAULT para que novas tentativas iniciem como não finalizadas
ALTER TABLE "Tentativa"
ALTER COLUMN finalizada SET DEFAULT FALSE;

-- DEFAULT para timestamp automático na criação de usuário
ALTER TABLE "Usuario"
ALTER COLUMN time_stamp SET DEFAULT CURRENT_TIMESTAMP;

-- -----------------------------------------------------
-- 4) REGRAS ON DELETE / ON UPDATE
-- -----------------------------------------------------

-- Primeiro removemos as constraints antigas para recriar com regras explícitas
ALTER TABLE "Tentativa"
DROP CONSTRAINT "fk_Tentativa_id_usuario";

ALTER TABLE "Tentativa"
ADD CONSTRAINT fk_Tentativa_id_usuario
FOREIGN KEY (id_usuario)
REFERENCES "Usuario"(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Justificativa:
-- Se um usuário for removido, suas tentativas também devem ser removidas.

ALTER TABLE "Quiz_Pergunta"
DROP CONSTRAINT "fk_Quiz_Pergunta_id_quiz";

ALTER TABLE "Quiz_Pergunta"
ADD CONSTRAINT fk_Quiz_Pergunta_id_quiz
FOREIGN KEY (id_quiz)
REFERENCES "Quiz"(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Justificativa:
-- Se um quiz for excluído, suas associações com perguntas também devem ser removidas.

-- =====================================================
-- [Projeto Final] — Etapa 5: Recursos Avançados
-- =====================================================


-- ===============================
-- VIEW
-- ===============================

-- View para facilitar a consulta de tentativas realizadas,
-- exibindo nome do usuário, título do quiz, pontuação e status.
-- Essa view evita a necessidade de JOIN manual frequente.
CREATE VIEW vw_relatorio_tentativas AS
SELECT
    t.id AS tentativa_id,
    u.nome AS usuario,
    q.titulo AS quiz,
    t.pontuacao_obtida,
    t.total_acertos,
    t.finalizada
FROM "Tentativa" t
JOIN "Usuario" u ON t.id_usuario = u.id
JOIN "Quiz" q ON t.id_quiz = q.id;


-- ===============================
-- VIEW MATERIALIZADA
-- ===============================

-- View materializada para gerar relatório de desempenho por quiz.
-- Calcula média de pontuação e total de tentativas por quiz.
-- Pode melhorar desempenho em consultas frequentes de relatórios.
CREATE MATERIALIZED VIEW mv_relatorio_quiz AS
SELECT
    q.id AS quiz_id,
    q.titulo,
    COUNT(t.id) AS total_tentativas,
    AVG(t.pontuacao_obtida) AS media_pontuacao
FROM "Quiz" q
LEFT JOIN "Tentativa" t ON q.id = t.id_quiz
GROUP BY q.id, q.titulo;


-- ===============================
-- TRIGGERS
-- ===============================

-- -----------------------------------------------------
-- TRIGGER BEFORE
-- -----------------------------------------------------

-- Função que garante que o total de acertos nunca seja negativo
CREATE OR REPLACE FUNCTION fn_validar_total_acertos()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.total_acertos < 0 THEN
        RAISE EXCEPTION 'Total de acertos não pode ser negativo.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger BEFORE INSERT ou UPDATE na tabela Tentativa
CREATE TRIGGER trg_validar_total_acertos
BEFORE INSERT OR UPDATE ON "Tentativa"
FOR EACH ROW
EXECUTE FUNCTION fn_validar_total_acertos();


-- -----------------------------------------------------
-- TRIGGER AFTER
-- -----------------------------------------------------

-- Tabela de log simples para registrar exclusões de usuários
CREATE TABLE log_exclusao_usuario (
    id SERIAL PRIMARY KEY,
    usuario_id INT,
    data_exclusao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Função que registra log após exclusão de usuário
CREATE OR REPLACE FUNCTION fn_log_exclusao_usuario()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_exclusao_usuario (usuario_id)
    VALUES (OLD.id);

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Trigger AFTER DELETE na tabela Usuario
CREATE TRIGGER trg_log_exclusao_usuario
AFTER DELETE ON "Usuario"
FOR EACH ROW
EXECUTE FUNCTION fn_log_exclusao_usuario();


-- ===============================
-- PROCEDURE
-- ===============================

-- Procedure para finalizar automaticamente uma tentativa,
-- alterando o campo finalizada para TRUE.
-- Deve ser executada com CALL.
CREATE OR REPLACE PROCEDURE sp_finalizar_tentativa(p_tentativa_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "Tentativa"
    SET finalizada = TRUE
    WHERE id = p_tentativa_id;
END;
$$;

-- =====================================================
-- AJUSTE FINAL PARA ORM (SQLAlchemy)
-- =====================================================
-- Garante auto incremento e sincroniza corretamente
-- mesmo quando executado do zero
-- =====================================================

-- Usuario
CREATE SEQUENCE IF NOT EXISTS usuario_id_seq;
ALTER SEQUENCE usuario_id_seq OWNED BY "Usuario"."id";
ALTER TABLE "Usuario"
ALTER COLUMN "id" SET DEFAULT nextval('usuario_id_seq');

SELECT setval('usuario_id_seq', (SELECT MAX(id) FROM "Usuario"));

-- Pergunta
CREATE SEQUENCE IF NOT EXISTS pergunta_id_seq;
ALTER SEQUENCE pergunta_id_seq OWNED BY "Pergunta"."id";
ALTER TABLE "Pergunta"
ALTER COLUMN "id" SET DEFAULT nextval('pergunta_id_seq');

SELECT setval('pergunta_id_seq', (SELECT MAX(id) FROM "Pergunta"));

-- Quiz
CREATE SEQUENCE IF NOT EXISTS quiz_id_seq;
ALTER SEQUENCE quiz_id_seq OWNED BY "Quiz"."id";
ALTER TABLE "Quiz"
ALTER COLUMN "id" SET DEFAULT nextval('quiz_id_seq');

SELECT setval('quiz_id_seq', (SELECT MAX(id) FROM "Quiz"));

-- Quiz_Pergunta
CREATE SEQUENCE IF NOT EXISTS quiz_pergunta_id_seq;
ALTER SEQUENCE quiz_pergunta_id_seq OWNED BY "Quiz_Pergunta"."id";
ALTER TABLE "Quiz_Pergunta"
ALTER COLUMN "id" SET DEFAULT nextval('quiz_pergunta_id_seq');

SELECT setval('quiz_pergunta_id_seq', (SELECT MAX(id) FROM "Quiz_Pergunta"));

-- Tentativa
CREATE SEQUENCE IF NOT EXISTS tentativa_id_seq;
ALTER SEQUENCE tentativa_id_seq OWNED BY "Tentativa"."id";
ALTER TABLE "Tentativa"
ALTER COLUMN "id" SET DEFAULT nextval('tentativa_id_seq');

SELECT setval('tentativa_id_seq', (SELECT MAX(id) FROM "Tentativa"));

