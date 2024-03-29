import sqlalchemy as sa
import sqlalchemy.orm as orm

from typing import List, Optional
from datetime import datetime

from models.models_base import ModelBase
from models.sabor import Sabor
from models.tipo_picole import TipoPicole
from models.tipo_embalagem import TipoEmbalagem
from models.ingrediente import Ingrediente
from models.conservante import Conservante
from models.aditivo_nutritivo import AditivoNutritivo


class Picole(ModelBase):
    __tablename__: str = 'picole'

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

    preco: float = sa.Column(
        sa.DECIMAL(8, 2),
        nullable=False
    )

    sabor_id: int = sa.Column(
        sa.Integer,
        sa.ForeignKey('sabor.id')
    )

    sabor: Sabor = orm.relationship(
        'Sabor',
        lazy='joined'
    )

    tipo_embalagem_id: int = sa.Column(
        sa.Integer,
        sa.ForeignKey('tipo_embalagem.id')
    )

    tipo_embalagem: TipoEmbalagem = orm.relationship(
        'TipoEmbalagem',
        lazy='joined'
    )

    tipo_picole_id: int = sa.Column(
        sa.Integer,
        sa.ForeignKey('tipo_picole.id')
    )

    tipo_picole: TipoPicole = orm.relationship(
        'TipoPicole',
        lazy='joined'
    )

    # Picolé pode ter vários ingredientes
    ingredientes_picole = sa.Table(
        'ingrediente_picole',
        ModelBase.metadata,
        sa.Column(
            'ingrediente_id',
            sa.Integer,
            sa.ForeignKey('ingrediente.id')
        ),
        sa.Column(
            'picole_id',
            sa.Integer,
            sa.ForeignKey('picole.id')
        )
    )

    ingredientes: Optional[List[Ingrediente]] = orm.relationship(
        'Ingrediente',
        secondary=ingredientes_picole,
        backref='ingrediente',
        lazy='joined'
    )

    # Picolé pode ter vários conservantes
    conservantes_picole = sa.Table(
        'conservantes_picole',
        ModelBase.metadata,
        sa.Column(
            'conservante_id',
            sa.Integer,
            sa.ForeignKey('conservante.id')
        ),
        sa.Column(
            'picole_id',
            sa.Integer,
            sa.ForeignKey('picole.id')
        )
    )

    conservantes: Optional[List[Conservante]] = orm.relationship(
        'Conservante',
        secondary=conservantes_picole,
        backref='conservante',
        lazy='joined'
    )

    # Picolé pode ter vários aditivos nutritivos
    aditivos_nutritivos_picole = sa.Table(
        'aditivos_nutritivos_picole',
        ModelBase.metadata,
        sa.Column(
            'aditivo_nutritivo_id',
            sa.Integer,
            sa.ForeignKey('aditivo_nutritivo.id')
        ),
        sa.Column(
            'picole_id',
            sa.Integer,
            sa.ForeignKey('picole.id')
        )
    )

    aditivos_nutritivos_picole: Optional[List[AditivoNutritivo]] = orm.relationship(
        'AditivoNutritivo',
        secondary=aditivos_nutritivos_picole,
        backref='aditivo_nutritivo',
        lazy='joined'
    )

    def __repr__(self) -> str:
        return (
            f'<Picole: {self.tipo_picole.nome} com sabor {self.sabor.nome}>'
            f'e preço {self.preco}'
        )
