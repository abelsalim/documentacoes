from tqdm import tqdm

def executa():
    # selecionando produto
    produtos = self.env['sped.produto'].search(
        [
            ('categoria_garantia_extendida_id', '!=', None)
        ]
    )

    # Itera em produtos no caso de cadastros duplicado no odoo
    for produto in tqdm(produtos):
        print(
            f'produto: {produto.codigo} - '
            f'desativado - {produto.active} - '
            'categoria_id: '
            f'{produto.categoria_garantia_extendida_id}'
        )

        # Escreve dados
        produto.categoria_garantia_extendida_id = None
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
    produtos.invalidate_cache()


executa()
