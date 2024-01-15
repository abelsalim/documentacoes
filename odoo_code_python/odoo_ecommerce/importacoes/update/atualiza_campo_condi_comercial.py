import csv


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


def executa(arquivo):
    with open(arquivo, 'r') as arquivo_csv:
        arquivo_csv = csv.reader(arquivo_csv, delimiter='|')

        dados_csv = []
        for linha in arquivo_csv:
            if not linha:
                continue

            codigo = linha[0]

            if len(codigo.split('/')) > 1:
                continue

            produto = self.env['sped.produto'].search(
                [
                    ('codigo', '=', codigo)
                ]
            )

            if not produto:
                continue

            if not (departamento := produto.departamento_ids):
                continue

            dep_nomes = departamento.departamento_superior_id.mapped('nome')

            if 'Móveis' not in dep_nomes:
                continue

            dados_csv.append(
                {
                    'codigo': produto.codigo,
                    'valor': 0.0
                }
            )

        if dados_csv:
            escreve_dados_csv(dados_csv, 'moveis_atualizado')

executa('/tmp/moveis.csv')
