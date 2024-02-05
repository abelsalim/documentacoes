import sqlalchemy as sa
from pathlib import Path
from typing import Optional

from sqlalchemy.future.engine import Engine
from sqlalchemy.orm import Session, sessionmaker

from sqlalchemy_py.scripts.secao_03_modelagem_dados.models import _all_models

from sqlalchemy_py.scripts.secao_03_modelagem_dados.constants.session import (
    db_session
)
from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.models_base import (
    ModelBase
)


class DatabaseManager:

    def __init__(self, sqlite: bool = False) -> None:
        self.sqlite = sqlite
        self._engine: Optional[Engine] = None

    def create_engine_postgre(self):
        # Criar mecanismo de banco de dados.
        self._engine = sa.create_engine(
            url=db_session.string_connection_postgresql,
            echo=False
        )

    def create_engine_sqlite(self) -> None:
        # Define diretório padrão para o database sqlite.
        folder = Path(db_session.arquivo_db).parent

        # Respeite o parents e se já existir não faça nada.
        folder.mkdir(parents=True)

        # Criar mecanismo de banco de dados.
        self._engine = sa.create_engine(
            url=db_session.string_connection_sqlite,
            echo=False,
            # Específico para sqlite: indica que não deve verificar se a mesma
            # thread está acessando o banco de dados.
            connect_args={'check_same_thread': False}
        )

    def create_engine(self) -> None:
        if self._engine:
            return

        # Gere o mecanismo do banco sqlite
        if self.sqlite:
            self.create_engine_sqlite()

        # Senão, gere do bando postgresql
        else:
            self.create_engine_postgre()

    def create_session(self) -> Session:
        if not self._engine:
            # Define Postgres
            self.create_engine()

        _session = sessionmaker(
            # Mecanismo do banco de dados
            self._engine,
            # Mantém objetos carregados pós commit
            expire_on_commit=False,
            # Seta a classe a ser utilizada
            class_=Session
        )

        session: Session = _session()

        return session

    def create_tables(self) -> None:
        if not self._engine:
            # Define Postgres
            self.create_engine()

        # Apaga a tabela se ja existir
        ModelBase.metadata.drop_all(self._engine)

        # Cria tabela
        ModelBase.metadata.create_all(self._engine)
