import math

from datetime import datetime
from asyncio import run, gather, to_thread
from programacao_conc_assinc.scripts.constants.asyncio import retorne


def computar(inicio, fim):
    '''
    Este método não é async pois gather que contém as threads já está sendo
    aguardada com 'await', portanto tornar esta função async faz-se necessário
    aguardar as threads com 'await' e portanto o código se torna síncrono.
    '''
    print(retorne.inicia_computacao.format(inicio, fim))
    fator = 1000 * 1000

    for pos in range(inicio, fim + 1):
        math.sqrt((pos - fator) * (pos - fator))

    print(retorne.finaliza_computacao.format(inicio, fim))


async def main():
    print(retorne.intro_async)

    inicio = datetime.now()

    await gather(
        to_thread(computar, 1, 10_000_000),
        to_thread(computar, 10_000_001, 20_000_000),
        to_thread(computar, 20_000_001, 30_000_000),
        to_thread(computar, 30_000_001, 40_000_000),
        to_thread(computar, 40_000_001, 50_000_000)
    )

    tempo = datetime.now() - inicio

    print(retorne.terminou_em.format(round(tempo.total_seconds(), 2)))


if __name__ == '__main__':
    run(main())

# Terminou em 5.55 segundos.
