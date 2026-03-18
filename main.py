from database import SessionLocal
from models import Usuario, Quiz, Tentativa

session = SessionLocal()

# ===============================
# CREATE
# ===============================
print("\n--- CREATE ---")

novo_usuario = Usuario(nome="Teste ORM", email="orm@email.com", matricula="MAT999")
session.add(novo_usuario)
session.commit()

print("Usuário inserido!")

# ===============================
# READ (com ordenação)
# ===============================
print("\n--- READ ---")

usuarios = session.query(Usuario).order_by(Usuario.nome).all()

for u in usuarios:
    print(u.id, u.nome)

# ===============================
# UPDATE
# ===============================
print("\n--- UPDATE ---")

user = session.query(Usuario).filter_by(matricula="MAT999").first()
if user:
    user.nome = "Nome Atualizado ORM"
    session.commit()
    print("Usuário atualizado!")

# ===============================
# DELETE
# ===============================
print("\n--- DELETE ---")

user = session.query(Usuario).filter_by(matricula="MAT999").first()
if user:
    session.delete(user)
    session.commit()
    print("Usuário removido!")

# ===============================
# CONSULTA 1 (JOIN)
# ===============================
print("\n--- JOIN Usuario + Tentativa ---")

dados = session.query(Tentativa).join(Usuario).all()

for t in dados:
    print(t.usuario.nome, t.pontuacao_obtida)

# ===============================
# CONSULTA 2 (JOIN com filtro)
# ===============================
print("\n--- JOIN com filtro ---")

dados = session.query(Tentativa)\
    .join(Quiz)\
    .filter(Quiz.titulo == "Quiz SQL Básico")\
    .all()

for t in dados:
    print(t.quiz.titulo, t.pontuacao_obtida)

# ===============================
# CONSULTA 3 (filtro + ordenação)
# ===============================
print("\n--- Filtro + Ordenação ---")

dados = session.query(Tentativa)\
    .filter(Tentativa.finalizada == True)\
    .order_by(Tentativa.pontuacao_obtida.desc())\
    .all()

for t in dados:
    print(t.pontuacao_obtida)

session.close()