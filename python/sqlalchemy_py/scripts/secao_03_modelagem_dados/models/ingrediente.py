import sqlalchemy as sa

from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.models_base import (
    ModelBase
)


class Ingrediente(ModelBase):
    __tablename__: str = 'ingredientes'

    id: int = sa.Column(
        sa.BigInteger,
        primary_key=True,
        autoincrement=True
    )

    nome: str = sa.Column(
        sa.String(45),
        unique=True,
        nullable=True
    )

    def __repr__(self) -> str:
        return f'<Ingrediente: {self.nome}>'
