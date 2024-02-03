from datetime import datetime
from asyncio import run, sleep, gather, Queue
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


async def main():
    total = 5_000
    dados = Queue()

    print(retorne.computando_dados.format(total * 2))

    # Executa a função 'gera_dados' de forma assíncrona em paralelo onde o '*'
    # serve para desempacotar - semelhante ao parâmetro '*args'.
    await gather(*(gerar_dados(total, dados) for _ in range(2)))

    # Retorna quantidade de dados.
    print(retorne.quantidade_dados.format(dados.qsize()))

    # Por fim executa a função processar dados.
    await processar_dados(dados.qsize(), dados)


if __name__ == '__main__':
    run(main())
