import sqlalchemy as sa
import sqlalchemy.orm as orm

from datetime import datetime

from models.models_base import ModelBase
from models.tipo_picole import TipoPicole


class Lote(ModelBase):
    __tablename__: str = 'lote'

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

    tipo_picole_id: int = sa.Column(
        sa.Integer,
        sa.ForeignKey('tipo_picole.id')
    )

    tipo_picole: TipoPicole = orm.relationship(
        'TipoPicole',
        lazy='joined'
    )

    quantidade: str = sa.Column(
        sa.Integer,
        nullable=False
    )

    def __repr__(self) -> str:
        return f'<Lote: {self.id}>'
