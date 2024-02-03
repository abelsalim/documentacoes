from datetime import datetime
from asyncio import run, sleep, Queue
from programacao_conc_assinc.scripts.constants.asyncio import retorne


async def processar_dados(quantidade, dados: Queue):
    print(retorne.aguarde_processamento.format(quantidade))

    processos = 0
    while processos < quantidade:
        processos += 1

        # Captura dados da 'Queue'
        await dados.get()
        await sleep(0.001)

    print(retorne.foram_processados.format(quantidade))


async def gerar_dados(quantidade, dados: Queue):
    print(retorne.aguarde_geracao.format(quantidade))

    for x in range(1, quantidade + 1):
        item = x * x

        # Adiciona ao future 'Queue'
        await dados.put((item, datetime.now()))
        await sleep(0.001)

    print(retorne.dados_gerados_com_sucesso)


if __name__ == '__main__':
    total = 5_000
    dados = Queue()

    print(retorne.computando_dados.format(total * 2))

    run(gerar_dados(total, dados))
    run(gerar_dados(total, dados))

    run(processar_dados(dados.qsize(), dados))
