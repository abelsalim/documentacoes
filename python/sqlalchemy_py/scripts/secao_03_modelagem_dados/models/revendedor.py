import sqlalchemy as sa

from datetime import datetime

from models.models_base import ModelBase


class Revendedor(ModelBase):
    __tablename__: str = 'revendedores'

    id: int = sa.Column(
        sa.BigInteger,
        primary_key=True,
        autoincrement=True
    )

    data_criacao: datetime = sa.Column(
        sa.DateTime,
        default=datetime.now,
        index=True
    )

    cnpj_cpf: str = sa.Column(
        sa.String(45),
        unique=True,
        nullable=False
    )

    nome: str = sa.Column(
        sa.String(100),
        unique=True,
        nullable=False
    )

    razao_social: str = sa.Column(
        sa.String(100),
        unique=True,
        nullable=False
    )

    celular: str = sa.Column(
        sa.String(11),
        unique=True,
        nullable=False
    )

    email: str = sa.Column(
        sa.String(100),
        unique=True,
        nullable=False
    )

    def __repr__(self) -> str:
        return f'<Revendedor: {self.nome}>'
