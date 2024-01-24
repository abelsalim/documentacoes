import time
import colorama

from queue import Queue
from threading import Thread
from programacao_concorrente_e_assincrona.scripts.constants.threads import (
    iniciando,
    retorno_dados
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
            colorama.Fore.RED + retorno_dados.format(valor * 2),
            flush=True
        )

        time.sleep(2)
        # O método task_done delimita cada item ou 'iterada' como uma tarefa,
        # portando cada finalização é uma 'conclusão bem sucedida'.
        queue.task_done()

def gera_dados(queue):
    for indice in range(1, 11):
        print(
            colorama.Fore.GREEN + retorno_dados.format(indice),
            flush=True
        )

        time.sleep(1)
        # queue.put() incere os valores do indice em uma lista própria dos
        # objetos instanciados
        queue.put(indice)


if __name__ == '__main__':
    # Delimita o início
    print(colorama.Fore.WHITE + iniciando, flush=True)
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
