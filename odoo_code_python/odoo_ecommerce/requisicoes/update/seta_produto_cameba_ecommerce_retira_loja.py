from tqdm import tqdm

# False == retira e entrega
# FURNITURE == somente entrega
# MATTRESSES == somente retira


def executa():
    # selecionando produto
    produtos = self.env['sped.produto'].search(
        [
            ('departamento_ids.departamento_superior_id.id', '=', 8),
            ('disponivel_ecommerce', '=', True),
            ('active', '=', True)
        ]
    )

    # Itera em produtos no caso de cadastros duplicado no odoo
    for produto in tqdm(produtos):
        print(f'produto: {produto.codigo}')

        if produto.vtex_modaltype == 'FURNITURE':
            produto._vtex_put(
                produto.vtex_url,
                produto.vtex_id,
                produto.vtex_json,
                produto.nome
            )
            print(55 * '-')
            continue

        # Escreve dados
        produto.vtex_modaltype = 'FURNITURE'
        produto.flush()
        self.env.cr.commit()

        produto._vtex_put(
            produto.vtex_url,
            produto.vtex_id,
            produto.vtex_json,
            produto.nome
        )

        print(f'produto: {produto.codigo} - Alterado!')

        print(55 * '-')

        # Limpando cache
        produto.invalidate_cache()


executa()


