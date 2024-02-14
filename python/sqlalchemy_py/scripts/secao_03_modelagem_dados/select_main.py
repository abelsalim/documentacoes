from sqlalchemy.orm import joinedload
from sqlalchemy.ext.automap import automap_base

from config.db_session import DatabaseManager
from constants.select import retorne_select

from utils.funcoes import set_trace


class DataBaseSelect:

    def __init__(self):
        self.model = False
        self.list_models = False
        self.base = automap_base()
        self.db_session = DatabaseManager()
        self.session = self.db_session.create_session()

    def __enter__(self):
        # Gera engine
        self.db_session.create_engine()
        # Prepara base
        self.prepara_base()
        # Gera lista dos models
        self.list_models = list(map(lambda x: x.__name__ , self.base.classes))

        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.session.close()

    def prepara_base(self):
        self.base.prepare(self.db_session._engine, reflect=True)

    def search(self, **kwargs):
        with self.session as session:
            # Montando query base
            query = session.query(self.model).options(joinedload('*'))

            # Inclusão de argumentos
            for key, value in kwargs.items():
                match key:
                    case 'filtro':
                        query = query.filter(value)
                    case 'order_by':
                        query = query.order_by(value)
                    case 'limit':
                        query = query.limit(value)
                    case 'count':
                        query = query.count()

            return query if kwargs.get('count') else query.all()

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
        query_full = select.select_table('picole').search(
            count=True,
            # limit=10
        )

        # Query parcial - com parâmetro where
        query_filter = select.select_table('picole').search(
            filtro=select.model.tipo_picole_id == 99,
            order_by=select.model.tipo_embalagem_id.desc(),
            limit=2
        )

        print(query_full)
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

        print(35 * '-')
        # print(len(query_full))
        print(35 * '-')
        print(len(query_filter))
