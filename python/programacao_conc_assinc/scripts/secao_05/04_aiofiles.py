import aiofiles

from asyncio import run
from programacao_conc_assinc.scripts.constants.asyncio import arquivos


async def exemplo_arquivo_1():
    async with aiofiles.open(arquivos.texto) as arquivo:
        conteudo = await arquivo.read()

    print(conteudo)


async def exemplo_arquivo_2():
    async with aiofiles.open(arquivos.texto) as arquivo:
        async for linha in arquivo:
            print(linha)


async def main():

    await exemplo_arquivo_1()
    await exemplo_arquivo_2()


if __name__ == '__main__':
    run(main())
