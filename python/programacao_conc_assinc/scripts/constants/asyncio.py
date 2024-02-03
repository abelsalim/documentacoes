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


arquivos = SimpleNamespace()

# Relacionado ao arquivos 'texto.txt' e 'links.txt'
arquivos.texto = f'./share/texto.txt'
arquivos.links = f'./share/links.txt'
