import multiprocessing

from multiprocessing import Pool
from programacao_conc_assinc.scripts.constants.multiprocessing import (
    QUANTIDADE_NUCLEOS,
    IMPRIME_PROCESSO_INI
)


def pool(tamanho_pool, funcao, entrada):
    with Pool(processes=tamanho_pool, initializer=imprimir_processo) as pool:

        # Entradas para o método calcular
        entrada = list(range(7))

        # Equivalente ao builtin map em sua usabilidade, mas sua função é
        # fragmentar o iterável afim de fornecer os equivalente para processar
        # na pool.
        saida = pool.map(funcao, entrada)

        print(saida)

        # Fecha a pool no sentido de impedir que mais processos/demandas sejam
        # adicionadas de forma posterior.
        pool.close()

        # Gera um ponto de encontro para a fragmentação realizada.
        pool.join()


def imprimir_processo():
    print(IMPRIME_PROCESSO_INI.format(multiprocessing.current_process().name))


def calcular(numero):
    # Retorno o número elevado.
    return numero ** 2


def main():
    # Captuta a quantidada de núcleos e multiplica por 2.
    # A idéia é lançar assim dois processos por núcleo existente.
    tamanho_pool = multiprocessing.cpu_count() * 2

    print(QUANTIDADE_NUCLEOS.format(tamanho_pool))

    # Entradas para o método calcular
    entrada = list(range(7))

    pool(tamanho_pool=tamanho_pool, funcao=calcular, entrada=entrada)


if __name__ == '__main__':
    main()
