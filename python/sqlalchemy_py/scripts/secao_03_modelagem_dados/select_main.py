from sqlalchemy.orm import joinedload
from sqlalchemy.ext.automap import automap_base

from config.db_session import DatabaseManager
from constants.select import retorne_select


class DataBaseSelect:

    def __init__(self):
        self.model = False
        self.base = automap_base()
        self.db_session = DatabaseManager()
        self.session = self.db_session.create_session()

    def __enter__(self):
        # Gera engine
        self.db_session.create_engine()
        # Prepara base
        self.prepara_base()

        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.session.close()

    def prepara_base(self):
        self.base.prepare(self.db_session._engine, reflect=True)

    def search(self, filtro=False):
        with self.session as session:
            if isinstance(filtro, bool):
                # Realiza query full
                return session.query(self.model).all()

            # Realiza adição dos dados instanciados
            return (
                session.query(self.model)
                .options(joinedload('*'))
                .filter(filtro)
                .all()
            )

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
    with DataBaseSelect() as select:
        # Query full - sem parâmetro where
        query_full = select.select_table('picole').search()

        # Query parcial - com parâmetro where
        query_filter = select.select_table('picole').search(
            select.model.tipo_picole_id == 99
        )

        print(len(query_filter))
        for picole in query_filter:
            print(35 * '-')

            print(picole.id)
            print(picole.data_criacao)

            print(picole.sabor_id)
            print(picole.sabor.nome)

            print(picole.tipo_embalagem.id)
            print(picole.tipo_embalagem.nome)

            print(picole.tipo_picole.id)
            print(picole.tipo_picole.nome)
