from types import SimpleNamespace


retorne = SimpleNamespace()

# Relacionado ao script '03_asyncio_v1.py'
retorne.aguarde_processamento = 'Aguarde o processamento de {} dados...'
retorne.foram_processados = 'Foram processados {} dados!!!'

retorne.aguarde_geracao = 'Aguarde a geração de {} dados...'
retorne.dados_gerados_com_sucesso = 'Dados gerados com sucesso!!!'

retorne.quantidade_dados = 'Quantidade de dados gerados: {}.'
retorne.computando_dados = 'Computando {} dados.'

# Relacionado ao script '04_aiohttp.py'
retorne.pegando_html = 'Pegando o HTML do curso {}'

# Relacionado ao script '05_performance_async.py'
retorne.intro_async = (
    'Realizando o processamento matemático de forma assíncrona.'
)
retorne.terminou_em = 'Terminou em {} segundos.'
retorne.inicia_computacao = 'Computando de {} até {}...'
retorne.finaliza_computacao = 'Computação de {} até {} concluída!!!'


arquivos = SimpleNamespace()

# Relacionado ao arquivos 'texto.txt' e 'links.txt'
arquivos.texto = f'./share/texto.txt'
arquivos.links = f'./share/links.txt'
