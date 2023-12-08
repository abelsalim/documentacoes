import csv


def escreve_dados_csv(dados, nome_arquivo):
    # Caminho padrão do arquivo
    diretorio = '/home/zenir/produtos_desativados_com_saldo'

    with open(f'{diretorio}/{nome_arquivo}', 'w', newline='') as arquivo_csv:
        cabecalho = ['CODIGO', 'QUANTIDADE', 'VR_UNITARIO']
        writer = csv.DictWriter(arquivo_csv, fieldnames=cabecalho, delimiter='|')

        print('Escrevendo dados!')

        writer.writeheader()
        writer.writerows(dados)

        print('Dados escritos!')


def executa():

    locais = locais = self.env['estoque.local'].search(
        [
            ('exibe_saldo_venda', '=', True)
        ]
    )

    for local in locais:
        # selecionando produto
        produtos = self.env['sped.produto'].search(
            [
                ('active', '=', False)
            ]
        )

        # Dados do arquivo csv
        dados_csv = []

        # Define o nome do arquivo
        nome_arquivo = f'{local.nome.replace(" ", "_")}.csv'

        for produto in produtos:
            # Captura o local superior
            local_superior = (
                produto.estoque_saldo_hoje_ids.local_id.local_superior_id
            )

            # Sai se não está contido no local superior
            if not local.id in local_superior.ids:
                continue

            print(f'Local de estoque: {local.nome}')
            print(f'Código do produto: {produto.codigo}')

            linha_csv = {
                'CODIGO': produto.codigo,
                'QUANTIDADE': 0,
                'VR_UNITARIO': produto.preco_venda
            }

            print(linha_csv)

            # Atualiza lista com dados
            dados_csv.append(linha_csv)
            print('Lista atualizada!')

        if dados_csv:
            escreve_dados_csv(dados_csv, nome_arquivo)

        print(70 * '-')


executa()
