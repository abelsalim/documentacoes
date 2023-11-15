import re

from tqdm import tqdm


def executa():
    # selecionando produto
    produtos = self.env['sped.produto'].search(
        [
            ('disponivel_ecommerce', '=', True)
        ]
    )

    # Itera em produtos no caso de cadastros duplicado no odoo
    for produto in tqdm(produtos):

        # Sai se não tem descrição
        if not produto.descricao_ecommerce:
            continue

        # Conteúdo compilado
        conteudo_style = re.compile(r'style="[^"]*"')

        # Removendo conteúdo style
        descricao = re.sub(conteudo_style, '', produto.descricao_ecommerce)

        # Remoção das tags font
        descricao = descricao.replace('<font style="font-size: 18px;"', '')
        descricao = descricao.replace('<font>', '')
        descricao = descricao.replace('<font >', '')
        descricao = descricao.replace('</font>', '')
        descricao = descricao.replace('< /font>', '')

        # Sai se descrição é igual a produção
        if produto.descricao_ecommerce == descricao:
            print(f'produto: {produto.codigo}')
            produto._sincroniza_vtex_product()
            continue

        # Escreve dados
        produto.descricao_ecommerce = descricao
        produto.flush()
        self.env.cr.commit()

        # Sincronizando com a vtex
        produto._sincroniza_vtex_product()

        print(f'produto: {produto.codigo}')
        print(55 * '-')

        # Limpando cache
        produto.invalidate_cache()


executa()
