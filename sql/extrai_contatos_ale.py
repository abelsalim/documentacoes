import csv

from tqdm import tqdm


produto = ''
marca = ''

data_inicio = '2023-01-01'
data_final = '2023-07-31'
tipo_venda = ('ecommerce', 'venda')
empresa = 379
valor_pedido = 4_000

filtro_produto = f"and produto.codigo = '{produto}'" if produto else ''
filtro_marca = f"and marca.id = '{marca}'" if marca else ''
filtra_valor = f"and pedido.vr_nf >= {valor_pedido}" if valor_pedido else ''

sql = f"""
    with dados as (
        select
            participante.nome as nome,
            participante.celular as numero
            -- case
            --     when pedido.numero like 'PV-%'
            --         and pedido.empresa_id = {empresa}
            --         then pedido.empresa_id
            --     when pedido.numero like 'EC-%'
            --         then pedido.empresa_id
            -- end as empresa

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
            -- {filtro_marca}
            {filtra_valor}
    ),

    agrupado as (
        select
            dados.nome,
            dados.numero
            -- dados.empresa

        from dados

        -- where dados.empresa is not null
    )

    select
        agrupado.nome,
        agrupado.numero

    from agrupado;
    """


self.env.cr.execute(sql)
dados = self.env.cr.fetchall()

lista_saida = []
pedido_documento = self.env['pedido.documento']

for tupla in dados:
    cliente, numero = tupla
    if not numero:
        continue

    nome_cliente = pedido_documento.trata_nome_sms(cliente)
    telefone = pedido_documento.trata_telefone_sms(numero)

    if not telefone:
        continue

    if (nome_cliente, telefone) not in lista_saida:
        lista_saida.append((nome_cliente, telefone))

    print(f'{nome_cliente} | {telefone}')

for arquivo in tqdm(lista_saida):
    arquivo = f'/tmp/contatos_meses_05_06_07_{len(lista_saida)}_contatos.csv'
    with open(arquivo, 'w', newline='') as arquivo_csv:
        writer = csv.writer(arquivo_csv)
        writer.writerows(lista_saida)
