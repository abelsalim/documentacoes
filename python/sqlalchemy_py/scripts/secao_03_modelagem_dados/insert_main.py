import sqlalchemy as sa

from sqlalchemy_py.scripts.secao_03_modelagem_dados.models.__all_models import *
from sqlalchemy_py.scripts.secao_03_modelagem_dados.constants.insert import retorno
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

    def create(self, classe, *args):
        # Cria objeto específico
        objeto = classe(*args)

        # Realiza Insert de dados
        retorno = self.realiza_insert(
            objeto,
            retorno.erro_duplicidade.format(', '.join(objeto.__dict__.keys())),
            retorno.insert_ok.format(classe.__name__)
        )

    def conservantes(self, nome, descricao):
        self.create(Conservante, nome, descricao)

    def ingredientes(self, nome):
        self.create(Ingrediente, nome)

    def tipo_picole(self, nome):
        self.create(TipoPicole, nome)

    def tipo_embalagem(self, nome):
        self.create(TipoEmbalagem, nome)

    def sabor(self, nome):
        self.create(Sabor, nome)

    def aditivo_nutritivo(self, nome, formula_quimica):
        self.create(AditivoNutritivo, nome, formula_quimica)

if __name__ == '__main__':
    insert = DataBaseInsert()

    # Aditivos nutritivos
    [insert.aditivo_nutritivo(*dados) for dados in retorno.tupla_aditivos]

    # Sabores
    [insert.sabor(*dados) for dados in retorno.tupla_sabores]

    # Tipo Embalagem
    [insert.tipo_embalagem(*dados) for dados in retorno.tupla_t_embalagem]

    # Tipo Picole
    [insert.tipo_picole(*dados) for dados in retorno.tupla_t_picole]

    # Ingrediente
    [insert.ingredientes(*dados) for dados in retorno.tupla_ingredientes]

    # Conservante
    [insert.conservantes(*dados) for dados in retorno.tupla_conservantes]
