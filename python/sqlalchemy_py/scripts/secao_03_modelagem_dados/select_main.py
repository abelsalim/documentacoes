from sqlalchemy import func
from sqlalchemy.ext.automap import automap_base

from config.db_session import DatabaseManager
from constants.select import retorne_select
from utils.funcoes import set_trace


class DataBaseSelect:

    def __init__(self):
        self.model = False
        self.base = automap_base()
        self.db_session = DatabaseManager()
        self.session = self.db_session.create_session()

    def __call__(self):
        # Gera engine
        self.db_session.create_engine()
        # Prepara base
        self.prepara_base()

    def prepara_base(self):
        self.base.prepare(self.db_session._engine, reflect=True)

    def search(self, filtro=False):
        with self.session as session:
            if isinstance(filtro, bool):
                # Realiza query full
                return session.query(self.model).all()

            # Realiza adição dos dados instanciados
            return session.query(self.model).filter(filtro).all()

    def select_table(self, tabela):
        if not isinstance(tabela, str):
            raise TypeError(retorne_select.atributo_str)

        if not tabela in self.base.classes:
            raise AttributeError(
                retorne_select.tabela_nao_existe.format(tabela=tabela)
            )

        self.model = self.base.classes.get(tabela)

        return self


if __name__ == '__main__':
    select = DataBaseSelect()
    select()

    query_full = select.select_table('lote').search()
    query_filter = select.select_table('lote').search(
        select.model.tipo_picole_id == 12
    )

    print(len(query_full))
    print(35 * '-')
    print(len(query_filter))
