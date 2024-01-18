import math
from datetime import datetime


def main():
    inicio = datetime.now()

    computar(fim=50_000_000)

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
