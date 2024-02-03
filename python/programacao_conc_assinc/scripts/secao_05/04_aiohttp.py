import bs4
import aiohttp
import aiofiles

from utils.funcoes import set_trace
from asyncio import run, create_task, gather
from programacao_conc_assinc.scripts.constants.asyncio import arquivos, retorne


def pegar_titulo(html):
    soup = bs4.BeautifulSoup(html, 'html.parser')

    # Captura título da página
    title = soup.select_one('title')
    # Busca apenas primeiro índice
    title = title.text.split('|')[0].strip()

    return title


async def pegar_html(link):
    print(retorne.pegando_html.format(link))

    # Instanciando session e realizando 'GET'
    async with aiohttp.ClientSession() as session:
        async with session.get(link) as resposta:
            if resposta.ok:
                return await resposta.text()

            print(f"Falha ao obter HTML do link {link}. Status: {resposta.status}")
            return None


async def pegar_links():
    # Captura links dentro do arquivo 'links.txt'
    async with aiofiles.open(arquivos.links) as arquivo:
        # Atribuindo links a uma lista
        links = [link.strip() for link in await arquivo.readlines()]

    return links


async def imprimir_titulos():
    # itera nos links para obter html das páginas
    htmls = await gather(*(pegar_html(link) for link in await pegar_links()))

    # Captura títulos e os transforma em uma string delimitadas por '\n'.
    titulos = '\n'.join([pegar_titulo(html) for html in htmls])

    print(f'\n{titulos}')


async def main():
    await imprimir_titulos()


if __name__ == '__main__':
    run(main())
