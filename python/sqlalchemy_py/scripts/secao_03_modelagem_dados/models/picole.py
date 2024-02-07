import sqlalchemy as sa
import sqlalchemy.orm as orm

from typing import List, Optional
from datetime import datetime
from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.models_base import (
    ModelBase
)
from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.sabor import (
    Sabor
)
from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.tipo_picole import (
    TipoPicole
)
from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.tipo_embalagem import (
    TipoEmbalagem
)
from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.ingrediente import (
    Ingrediente
)
from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.conservante import (
    Conservante
)
from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.aditivo_nutritivo import (
    AditivoNutritivo
)


class Picole(ModelBase):
    __tablename__: str = 'picoles'

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
        sa.ForeignKey('sabores.id')
    )

    sabor: Sabor = orm.relationship(
        'Sabor',
        lazy='joined'
    )

    tipo_embalagem_id: int = sa.Column(
        sa.Integer,
        sa.ForeignKey('tipos_embalagem.id')
    )

    tipo_embalagem: TipoEmbalagem = orm.relationship(
        'TipoEmbalagem',
        lazy='joined'
    )

    tipo_picole_id: int = sa.Column(
        sa.Integer,
        sa.ForeignKey('tipos_picole.id')
    )

    tipo_picole: TipoPicole = orm.relationship(
        'TipoPicoles',
        lazy='joined'
    )

    # Picolé pode ter vários ingredientes
    ingredientes_picole = sa.Table(
        'ingredientes_picole',
        ModelBase.metadata,
        sa.Column(
            'ingrediente_id',
            sa.Integer,
            sa.ForeignKey('ingredientes.id')
        ),
        sa.Column(
            'picole_id',
            sa.Integer,
            sa.ForeignKey('picoles.id')
        )
    )

    ingredientes: List[Ingrediente] = orm.relationship(
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
            sa.ForeignKey('conservantes.id')
        ),
        sa.Column(
            'picole_id',
            sa.Integer,
            sa.ForeignKey('picoles.id')
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
            sa.ForeignKey('aditivos_nutritivos.id')
        ),
        sa.Column(
            'picole_id',
            sa.Integer,
            sa.ForeignKey('picoles.id')
        )
    )

    aditivos_nutritivos_picole: Optional[List[Ingrediente]] = orm.relationship(
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
