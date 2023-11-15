from tqdm import tqdm


def executa():
    # selecionando produto
    produtos = self.env['sped.produto'].search(
        [
            ('departamento_ids.departamento_superior_id.id', 'in', (195, 196, 287, 288)),
            ('disponivel_ecommerce', '=', True)
        ]
    )

    # Itera em produtos no caso de cadastros duplicado no odoo
    for produto in tqdm(produtos):
        print(f'produto: {produto.codigo}')

        if produto.vtex_modaltype == 'MATTRESSES':
            continue

        # Escreve dados
        produto.vtex_modaltype = 'MATTRESSES'
        produto.flush()
        self.env.cr.commit()

        print(f'produto: {produto.codigo} - Alterado!')

        print(55 * '-')

        # Limpando cache
        produto.invalidate_cache()


executa()
