import sqlalchemy as sa

# O pathlib é utilizado com sqlite
from pathlib import Path
from typing import Optional

from sqlalchemy.orm import Session
from sqlalchemy.future.engine import Engine
from sqlalchemy.orm import sessionmaker

from sqlalchemy_py.scripts.secao_03_modelagem_dados.constants.session import (
    db_session
)
from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.models_base import (
    ModelBase
)


__engine: Optional[Engine]


def create_engine_postgre():
    global __engine

    # Criar mecanismo de banco de dados.
    __engine = sa.create_engine(
        url=db_session.string_connection_postgresql,
        echo=False
    )


def create_engine_sqlite():
    global __engine

    # Define diretório padrão para o database sqlite.
    folder = Path(db_session.arquivo_db).parent

    # Respeite o parents e se já existir não faça nada.
    folder.mkdir(parents=True)

    # Criar mecanismo de banco de dados.
    __engine = sa.create_engine(
        url=db_session.string_connection_sqlite,
        echo=False,
        # Específico para sqlite: sea que não deve verificar se a mesma
        # thread está acessando o banco de dados.
        connect_args={'check_same_thread': False}
    )


def create_engine(sqlite: bool = False):
    global __engine

    if __engine:
        return

    # Gere o mecanismo do banco bateado o boolean 'sqlite'
    create_engine_postgre() if sqlite else create_engine_sqlite()

    return __engine

