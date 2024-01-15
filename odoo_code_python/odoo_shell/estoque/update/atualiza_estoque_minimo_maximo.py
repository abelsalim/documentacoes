from decimal import Decimal as D


def cria_minimo_maximo(local, produto):
    dados = {
        'local_id': local.id,
        'produto_id': produto.id,
        'quantidade_minima': 3,
        'quantidade_maxima': 1000
    }

    print(
        f'Registrando: produto {produto.codigo} - local {local.nome_completo}'
    )

    minimo_maximo = self.env['estoque.minimo.maximo']
    minimo_maximo.create(dados)
    self.env.cr.commit()

    print(f'produto {produto.codigo} registrando!')
    print(75 * '-')

    # Limpando cache
    minimo_maximo.invalidate_cache()


def executa():
    # Seleciona locais de estoque
    locais = self.env['estoque.local'].search(
        [
            ('tipo', '=', 'A'),
            ('exibe_saldo_venda', '=', True),
            ('id', 'not in', (738, 822, 721, 202, 145, 156))
        ]
    )

    # seleciona produtos
    produtos = self.env['sped.produto'].search(
        [
            ('disponivel_ecommerce', '=', True),
            ('active', '=', True),
            ('permite_venda', '=', True)
        ]
    )

    for local in locais:
        for produto in produtos:
            try:
                # Sai se não existe objeto do produto ou local
                if not produto or not local:
                    continue

                produto_mm = produto.estoque_minimo_maximo_ids

                produto_mm = [
                    mm for mm in produto_mm if local.id == mm.local_id.id
                ]

                # Entra se indice do local existe no estoque_mm
                if produto_mm:

                    # desempacotando lista
                    produto_mm = produto_mm[0]

                    lista_condicional_estoque_minimo_maximo = [
                        produto_mm.quantidade_minima == D(3),
                        produto_mm.quantidade_maxima == D(1000),
                    ]

                    if all(lista_condicional_estoque_minimo_maximo):
                        print(
                            f'Produto {produto.codigo} já atualizado '
                            f'no local {local.nome_completo}'
                        )
                        print(75 * '-')
                        continue

                    # Insere os dados
                    produto_mm.quantidade_minima = D(3)
                    produto_mm.quantidade_maxima = D(1000)

                    # Salva no banco
                    produto.flush()
                    self.env.cr.commit()

                    print(
                        f'Atualizando dados do produto {produto.codigo} '
                        f'no local {local.nome_completo}'
                    )
                    print(75 * '-')

                    # Limpando cache
                    produto.invalidate_cache()

                    continue

                cria_minimo_maximo(local, produto)

                # Limpando cache
                produto.invalidate_cache()

            except ValueError as e:
                print(e)

            # Limpando cache
            local.invalidate_cache()


executa()
