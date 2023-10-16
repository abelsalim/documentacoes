produto = ''
marca = '746'

data_inicio = '2023-07-01'
data_final = '2023-07-31'
tipo_venda = ('ecommerce', 'venda')

filtro_produto = f"and produto.codigo = '{produto}'" if produto else ''
filtro_marca = f"and marca.id = '{marca}'" if marca else ''


sql = f"""
    select
        pedido.numero,
        pedido.vtex_id,
        participante.nome,
        participante.celular

    from
        pedido_documento as pedido
        join sped_participante as participante
            on participante.id = pedido.participante_id
        join sped_documento_item as item
            on item.pedido_id = pedido.id
        join sped_produto as produto
            on produto.id = item.produto_id
        join sped_produto_familia as familia
            on familia.id = produto.familia_id
        join sped_produto_marca as marca
            on marca.id = produto.marca_id

    where
        pedido.data_aprovacao between '{data_inicio}' and '{data_final}'
        and pedido.tipo in {tipo_venda}
        -- {filtro_produto}
        -- {filtro_marca};
    """

self.env.cr.execute(sql)
dados = self.env.cr.fetchall()

lista_saida = []
pedido_documento = self.env['pedido.documento']
for_1 = 0
for_2 = 0
for tupla in dados:
    cliente, numero = tupla
    if not numero:
        continue

    nome_cliente = pedido_documento.trata_nome_sms(cliente)
    telefone = pedido_documento.trata_telefone_sms(numero)

    if not telefone:
        continue

    lista_saida.append((nome_cliente, telefone))

    print(f'{nome_cliente} | {telefone}')



print(f'total de registros: {len(dados)}'.title())
