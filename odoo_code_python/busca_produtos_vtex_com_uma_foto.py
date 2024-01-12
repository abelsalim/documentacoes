from tqdm import tqdm


def executa():
    produtos = self.env['sped.produto'].search(
        [
            ('disponivel_ecommerce', '=', True),
            ('active', '=', True),
            ('permite_venda', '=', True)
        ]
    )

    lista_produtos_sem_imagem = []
    lista_produtos_uma_imagem = []

    for produto in tqdm(produtos):
        if not produto or not produto.vtex_id:
            continue

        url = f'api/catalog/pvt/stockkeepingunit/{produto.vtex_id}/file'

        lista = produto._vtex_get(url, False, False, False, retorna_json=True)


        if not lista:
            lista_produtos_sem_imagem.append(produto.codigo)
        elif len(lista) == 1:
            lista_produtos_uma_imagem.append(produto.codigo)

        produto.invalidate_cache()

executa()
