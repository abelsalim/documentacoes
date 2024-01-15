import csv

from json import JSONDecodeError
from zenir.models.vtex.vtex_requisicao import VtexRequisicao


def escreve_dados_csv(dados, nome_arquivo):
    # Caminho padrão do arquivo
    diretorio = '/tmp'

    with open(f'{diretorio}/{nome_arquivo}', 'w', newline='') as arquivo_csv:
        cabecalho = ['codigo', 'valor']
        writer = csv.DictWriter(arquivo_csv, fieldnames=cabecalho, delimiter=',')

        print('Escrevendo dados!')

        writer.writeheader()
        writer.writerows(dados)

        print('Dados escritos!')


model = VtexRequisicao()

lista_get = []
for vtex_id in [323, 179]:
    for page in range(1, 100):
        url = f'api/catalog/pvt/collection/{vtex_id}/products?page={page}&pageSize=50'
        retorno_json = model._api_vtex(get=True, vtex_url=url, retorna_json=True)

        if retorno_json.get('Size') == 0:
            break

        lista = retorno_json.get('Data')
        lista_get.extend([dicionario.get('SkuId') for dicionario in lista])


produtos_get = self.env['sped.produto'].search([('vtex_id', 'in', lista_get)])

lista_eletro = []
for produto in produtos_get:
    if not (departamento := produto.departamento_ids):
        continue

    dep_nomes = departamento.departamento_superior_id.mapped('nome')

    if 'Eletrodomésticos' not in dep_nomes:
        continue

    lista_eletro.append(produto.codigo)

produtos_eletros = self.env['sped.produto'].search(
    [
        ('departamento_ids.departamento_superior_id.nome', '=', 'Eletrodomésticos'),
        ('disponivel_ecommerce', '=', True)
    ]
)

dados_csv = []
for produto in produtos_eletros:
    if produto.codigo in lista_eletro:
        continue

    dados_csv.append(
        {
            'codigo': produto.codigo,
            'valor': 0.0
        }
    )


escreve_dados_csv(dados_csv, 'eletro_collection.csv')
