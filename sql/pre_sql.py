where_empresa = ''
if len(executa.empresa_id) == 1:
    where_empresa = f'and sd.empresa_id = {executa.empresa_id.id}'

where_familia = ''
if len(executa.familia_ids) == 1:
    where_familia += f'and spf.familia_superior_id = {executa.familia_ids.id}'

elif len(executa.familia_ids) > 1:
    where_familia += f'and spf.familia_superior_id  in {tuple(executa.familia_ids.ids)}'

where_produto = ''
if len(executa.produto_ids) == 1:
    where_produto = f'and sp.id = {executa.produto_ids.id}'

elif len(executa.produto_ids) > 1:
    where_produto = f'and sp.id in {executa.produto_ids.ids}'

where_fornecedor = ''
fornecedor = executa.fornecedor_id
if fornecedor:
    # Se é grupo econômico retorna toda a lista dos integrantes
    if fornecedor.eh_grupo_economico:
        lista_ids = fornecedor.grupo_economico_ids.ids

    # Se não é grupo econômico mas tem id em grupo econômico, retorno a lista
    # com todos os integrantes
    elif fornecedor.grupo_economico_id:
        lista_ids = fornecedor.grupo_economico_id.grupo_economico_ids.ids

    # Se não tem id em um grupo econômico retorna o próprio id
    else:
        lista_ids = fornecedor.ids

    if len(lista_de_ids) == 1:
        where_fornecedor = f'and sp.fabricante_id = {lista_ids[0]}'

    else:
        where_fornecedor = f'and sp.fabricante_id in {tuple(lista_ids)}'
