import time
import colorama

from queue import Queue
from threading import Thread
from programacao_conc_assinc.scripts.constants.threads import (
    INICIANDO,
    RETORNO_DADOS
)


def consumir_dados(queue):
    """
    Através dos dados gerados na função 'gera_dados()', iremos utilizar a lista
    armazenada em queue iterando em seus valor armazenados.
    """
    while queue.qsize() > 0:
        # Assim como os geradores, o método get retorna o valor de queue e
        # também o remove do iterável.
        valor = queue.get()

        print(
            colorama.Fore.RED + RETORNO_DADOS.format(valor * 2),
            flush=True
        )

        time.sleep(2)
        # O método task_done delimita cada item ou 'iterada' como uma tarefa,
        # portando cada finalização é uma 'conclusão bem sucedida'.
        queue.task_done()

def gera_dados(queue):
    for indice in range(1, 11):
        print(
            colorama.Fore.GREEN + RETORNO_DADOS.format(indice),
            flush=True
        )

        time.sleep(1)
        # queue.put() incere os valores do indice em uma lista própria dos
        # objetos instanciados
        queue.put(indice)


if __name__ == '__main__':
    # Delimita o início
    print(colorama.Fore.WHITE + INICIANDO, flush=True)
    # Instanciando classe Queue
    queue = Queue()

    # Criando threads
    t1 = Thread(target=gera_dados, args=(queue,))
    t2 = Thread(target=consumir_dados, args=(queue,))

    # Iniciando e executando thread 1
    t1.start()
    t1.join()

    # Iniciando e executando thread 2
    t2.start()
    t2.join()
