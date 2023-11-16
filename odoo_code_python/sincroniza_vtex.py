from tqdm import tqdm
from decimal import Decimal as D


def atualiza_saldo_produto(produto):
    produto._vtex_atualiza_saldo()
    self.env.cr.commit()

    print(f'produto: {produto.codigo} - saldo atualizado!')

    # Limpando cache
    produto.invalidate_cache()

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


def atualiza_produto_minimo_maximo(locais, produto):
    for local in locais:
        try:
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


def deleta_produto_minimo_maximo(locais, produto):
    for mm in produto.estoque_minimo_maximo_ids:
        if mm.local_id.id not in locais.ids:
            print(
                f'deletando local: {mm.local_id.nome} - '
                f'produto: {produto.codigo}'
            )

            mm.unlink()
            self.env.cr.commit()


def executa(deleta_mm=False, atualiza_mm=False, atualiza_saldo=False):
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

    for produto in tqdm(produtos):

        if deleta_mm:
            deleta_produto_minimo_maximo(locais, produto)


        if atualiza_mm:
            atualiza_produto_minimo_maximo(locais, produto)

        if atualiza_saldo:
            atualiza_saldo_produto(produto)


executa(atualiza_saldo=True)
