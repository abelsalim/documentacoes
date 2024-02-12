import sqlalchemy as sa
import sqlalchemy.orm as orm

from typing import List
from datetime import datetime

from models.lote import Lote
from models.revendedor import Revendedor
from models.models_base import ModelBase


class NotaFiscal(ModelBase):
    __tablename__: str = 'nota_fiscal'

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

    revendedor_id: int = sa.Column(
        sa.Integer,
        sa.ForeignKey('revendedor.id')
    )

    revendedor: Revendedor = orm.relationship(
        'Revendedor',
        lazy='joined'
    )

    valor: float = sa.Column(
        sa.DECIMAL(8, 2),
        nullable=False
    )

    numero_serie: str = sa.Column(
        sa.String(45),
        unique=True,
        nullable=False
    )

    descricao: str = sa.Column(
        sa.String(200),
        nullable=False
    )

    # Nota fiscal pode ter vários lotes
    lotes_nota_fiscal = sa.Table(
        'lotes_nota_fiscal',
        ModelBase.metadata,
        sa.Column(
            'nota_fiscal_id',
            sa.Integer,
            sa.ForeignKey('nota_fiscal.id')
        ),
        sa.Column(
            'lote_id',
            sa.Integer,
            sa.ForeignKey('lote.id')
        )
    )

    lotes: List[Lote] = orm.relationship(
        'Lote',
        secondary=lotes_nota_fiscal,
        backref='lote',
        lazy='dynamic'
    )

    def __repr__(self) -> str:
        return f'<Nota Fiscal: {self.numero_serie}>'
