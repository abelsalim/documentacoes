import sqlalchemy as sa

from models.lote import Lote
from models.sabor import Sabor
from models.picole import Picole
from constants.insert import retorne
from models.revendedor import Revendedor
from models.nota_fiscal import NotaFiscal
from models.tipo_picole import TipoPicole
from models.ingrediente import Ingrediente
from models.conservante import Conservante
from config.db_session import DatabaseManager
from models.tipo_embalagem import TipoEmbalagem
from models.aditivo_nutritivo import AditivoNutritivo

from utils.funcoes import set_trace


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

            except sa.exc.DataError as erro:
                # Restaura estado anterior - rollback
                session.rollback()

                return str(erro.orig)

        return retorno_ok

    def create(self, classe, **dados):
        # Cria objeto específico
        objeto = classe(**dados)

        # Caprua atributos criados
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


if __name__ == '__main__':
    insert = DataBaseInsert()

    # As listas com suas classes
    lista_dicionario = [
        # Aditivos nutritivos
        {AditivoNutritivo: retorne.tupla_aditivos},
        # Sabores
        {Sabor: retorne.tupla_sabores},
        # Tipo Embalagem
        {TipoEmbalagem: retorne.tupla_t_embalagem},
        # Tipo Picole
        {TipoPicole: retorne.tupla_t_picole},
        # Ingrediente
        {Ingrediente: retorne.tupla_ingredientes},
        # Conservante
        {Conservante: retorne.tupla_conservantes},
        # Revendedor
        {Revendedor: retorne.tupla_revendedor},
        # Lote
        {Lote: retorne.tupla_lote},
        # NotaFiscal
        {NotaFiscal: retorne.tupla_nota_fical},
    ]

    # Função anônima que filtra 'Chave' e 'Valor' atribuindo a uma lista
    # agregando respectivamente a uma lista denominada 'dados' onde a mesma é
    # Chamada em um comprehension que realiza um incremental em cada tupla
    # contida em 'dados'.
    # O 'next' é necessário pq no fundo um 'map' ainda é um simples 'generator'.
    insert_lambda = lambda dicionario: next(
        map(
            lambda dados: [
                insert.create(dados[0], **dicionario) for dicionario in dados[1]
            ], filter(
                lambda lista_dados: lista_dados, dicionario.items()
            )
        )
    )

    # Executor
    _ = list(map(insert_lambda, lista_dicionario))
