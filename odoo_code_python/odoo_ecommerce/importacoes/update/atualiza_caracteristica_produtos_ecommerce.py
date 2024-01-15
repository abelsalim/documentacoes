from tqdm import tqdm

def atualiza_cc_produtos_ecommerce():
    # seleciona produtos
    produtos = self.env['sped.produto'].search(
        [
            ('disponivel_ecommerce', '=', True),
            ('active', '=', True),
            ('permite_venda', '=', True)
        ]
    )

    for produto in tqdm(produtos):
        # Método que atualiza via api
        produto._atualiza_caracteristicas()

        # Limpando cache
        produto.invalidate_cache()


atualiza_cc_produtos_ecommerce()
