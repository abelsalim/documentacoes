import sqlalchemy as sa

from datetime import datetime
from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.models_base import (
    ModelBase
)


class TipoPicoles(ModelBase):
    __tablename__: str = 'tipos_picole'

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

    nome: str = sa.Column(
        sa.String(45),
        unique=True,
        nullable=True
    )

    def __repr__(self) -> str:
        return f'<Tipo Picole: {self.nome}>'
