import sqlalchemy as sa

from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.__all_models import *
from sqlalchemy_py.scripts.secao_03_modelagem_dados.constants.insert import retorne
from sqlalchemy_py.scripts.secao_03_modelagem_dados.config.db_session import DatabaseManager


class DataBaseInsert:

    def __init__(self):
        self.db_session = DatabaseManager()
        self.session = self.db_session.create_session()

    def realiza_insert(self, objeto, retorno_Erro, retorno_ok):
        with self.session as session:
            try:
                # Realiza adição dos dados instanciados
                session.add(objeto)
                # Salva os dados - commit
                session.commit()

            # Dispara exceção quando objeto instanciado for duplicado
            except sa.exc.IntegrityError:
                # Restaura estado anterior - rollback
                session.rollback()

                return retorno_Erro

        return retorno_ok

    def create(self, classe, **dados):
        # Cria objeto específico
        objeto = classe(**dados)

        atributos = [
            k for k, v in objeto.__dict__.items() if isinstance(v, str)
        ]

        # Realiza Insert de dados
        retorno = self.realiza_insert(
            objeto,
            retorne.erro_duplicidade.format(
                classe.__name__,
                ', '.join(atributos)
            ),
            retorne.insert_ok.format(classe.__name__)
        )

        print(retorno)

    def conservantes(self, **kwargs):
        self.create(Conservante, **kwargs)

    def ingredientes(self, **kwargs):
        self.create(Ingrediente, **kwargs)

    def tipo_picole(self, **kwargs):
        self.create(TipoPicole, **kwargs)

    def tipo_embalagem(self, **kwargs):
        self.create(TipoEmbalagem, **kwargs)

    def sabor(self, **kwargs):
        self.create(Sabor, **kwargs)

    def aditivo_nutritivo(self, **kwargs):
        self.create(AditivoNutritivo, **kwargs)

if __name__ == '__main__':
    insert = DataBaseInsert()

    # Aditivos nutritivos
    [insert.aditivo_nutritivo(**dados) for dados in retorne.tupla_aditivos]

    # Sabores
    [insert.sabor(**dados) for dados in retorne.tupla_sabores]

    # Tipo Embalagem
    [insert.tipo_embalagem(**dados) for dados in retorne.tupla_t_embalagem]

    # Tipo Picole
    [insert.tipo_picole(**dados) for dados in retorne.tupla_t_picole]

    # Ingrediente
    [insert.ingredientes(**dados) for dados in retorne.tupla_ingredientes]

    # Conservante
    [insert.conservantes(**dados) for dados in retorne.tupla_conservantes]
