import math

from datetime import datetime
from multiprocessing import cpu_count
from concurrent.futures.process import ProcessPoolExecutor as Executor


def computar(fim, inicio):
    pos = inicio
    fator = 1000 * 1000

    while pos < fim:
        pos += 1
        math.sqrt((pos - fator) * (pos - fator))


def main():
    qtd_cores = cpu_count()
    print(f'Utilizando {qtd_cores} core(s)')

    inicio = datetime.now()

    with Executor(max_workers=qtd_cores) as executor:
        for n in range(1, qtd_cores + 1):
            ini = 50_000_000 * (n - 1) / qtd_cores
            fim = 50_000_000 * n / qtd_cores

            future = executor.submit(computar, inicio=ini, fim=fim)

        print(f'Core {n} processando de {ini} até {fim}.')

    tempo = datetime.now() - inicio

    print(f'Terminou em {tempo.total_seconds():.2f} segundos.')


if __name__ == '__main__':
    main()


# 1º Terminou em 3.97 segundos.
