import csv


def executa(arquivo):
    with open(arquivo, 'r') as arquivo_csv:
        arquivo_csv = csv.reader(arquivo_csv, delimiter='|')
        try:
            for linha in arquivo_csv:
                codigo, categoria = linha

                # selecionando produto
                produtos = self.env['sped.produto'].search(
                    [
                        ('codigo', '=', codigo),
                        ('active', '=', True)
                    ]
                )

                # selecionando categoria
                categorias = self.env['faixa.preco.garantia.categoria'].search(
                    [('name', '=', categoria.strip())]
                )

                # Se não tem o produtos ou categorias continua
                if not produtos or not categorias:
                    continue

                # Itera em produtos no caso de cadastros duplicado no odoo
                for produto in produtos:
                    # Itera em categoria no caso de vim duplicado
                    for categoria in categorias:

                        # Sai se campo já atualizado
                        if produto.categoria_garantia_extendida_id.id == categoria.id:
                            continue

                        print(
                            f'produto: {produto.codigo} - '
                            f'desativado - {produto.active} - '
                            'categoria_id: '
                            f'{produto.categoria_garantia_extendida_id}'
                        )

                        # Escreve dados
                        produto.categoria_garantia_extendida_id = categoria.id
                        produto.flush()
                        self.env.cr.commit()

                        print(
                            f'produto: {produto.codigo} - '
                            f'desativado - {produto.active} - '
                            'categoria_id: '
                            f'{produto.categoria_garantia_extendida_id}'
                        )

                        print(55 * '-')

                    # Limpando cache
                    categorias.invalidate_cache()

                # Limpando cache
                produtos.invalidate_cache()

        except ValueError:
            print(ValueError)

        except TypeError:
            print(produto.codigo)


executa('/tmp/nomefaixagr.csv')
