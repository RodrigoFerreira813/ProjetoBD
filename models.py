from sqlalchemy import Column, Integer, String, ForeignKey, Boolean, Text
from sqlalchemy.orm import declarative_base, relationship

Base = declarative_base()

class Usuario(Base):
    __tablename__ = "Usuario"

    id = Column(Integer, primary_key=True)
    nome = Column(String(100), nullable=False)
    email = Column(String(100), nullable=False)
    matricula = Column(String(50), nullable=False)

    tentativas = relationship("Tentativa", back_populates="usuario")


class Quiz(Base):
    __tablename__ = "Quiz"

    id = Column(Integer, primary_key=True)
    titulo = Column(String)

    tentativas = relationship("Tentativa", back_populates="quiz")


class Pergunta(Base):
    __tablename__ = "Pergunta"

    id = Column(Integer, primary_key=True)
    enunciado = Column(Text)
    tema = Column(String)


class Tentativa(Base):
    __tablename__ = "Tentativa"

    id = Column(Integer, primary_key=True)
    id_usuario = Column(Integer, ForeignKey("Usuario.id"))
    id_quiz = Column(Integer, ForeignKey("Quiz.id"))
    pontuacao_obtida = Column(Integer)
    finalizada = Column(Boolean)

    usuario = relationship("Usuario", back_populates="tentativas")
    quiz = relationship("Quiz", back_populates="tentativas")