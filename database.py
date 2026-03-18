from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# 🔧 ALTERE AQUI COM SEUS DADOS
DATABASE_URL = "postgresql://postgres:1910@localhost:5432/banco_quiz"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)