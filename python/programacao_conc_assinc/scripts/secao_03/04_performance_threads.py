import math
import multiprocessing

from threading import Thread
from datetime import datetime


def main():
    qtd_cores = multiprocessing.cpu_count()
    print(f'Utilizando {qtd_cores} core(s)')

    inicio = datetime.now()

    threads = []
    for n in range(1, qtd_cores + 1):
        ini = 50_000_000 * (n - 1) / qtd_cores
        fim = 50_000_000 * n / qtd_cores

        print(f'Core {n} processando de {ini} até {fim}.')
        threads.append(
            Thread(
                target=computar,
                kwargs={'inicio': ini, 'fim': fim},
                # Se o processo pai morrer os filhos continuam
                daemon=True
            )
        )

    # inicia e delimita fim das threads
    [tarefa.start() for tarefa in threads]
    [tarefa.join() for tarefa in threads]

    tempo = datetime.now() - inicio

    print(f'Terminou em {tempo.total_seconds():.2f} segundos.')


def computar(fim, inicio=1):
    pos = inicio
    fator = 1000 * 1000
    while pos < fim:
        pos += 1
        math.sqrt((pos - fator) * (pos - fator))


main()

# 1º Terminou em 9.36 segundos.
