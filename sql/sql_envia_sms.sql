-- Então. Você precisa fazer um SQL cruzando o a sped_documento_item com a
-- pedido documento  o campo de relacionamento é o pedido_id na tabela do item

-- Depois disso

-- Tem que cruzar o pedido com a sped_participante pra pegar o número de telefone
-- E precisa cruzar a sped_documento_item com a sped_produto o campo de relacionamento
-- é produto_id aí você faz a busca pelo código na sped_produto

-- self.env.cr.execute(sql)


-- Captura vendas por tipo ecommerce
select
	sped_par.nome,
	sped_par.celular
from pedido_documento as pd
join sped_participante as sped_par
	on sped_par.id = pd.participante_id
where pd.data_aprovacao between '2023-05-01' and '2023-05-31'
	and pd.tipo = 'ecommerce';


-- Captura vendas por produto comprado no ecommerce
select
	pd.numero,
	sped_par.nome,
	sped_par.celular
from pedido_documento as pd
join sped_participante as sped_par
	on sped_par.id = pd.participante_id
join sped_documento_item as sped_doc_item
	on sped_doc_item.pedido_id = pd.id
join sped_produto as sped_pro
	on sped_pro.id = sped_doc_item.produto_id
where pd.data_aprovacao between '2023-05-01' and '2023-05-31'
	and pd.tipo = 'ecommerce'
	and sped_pro.codigo = '22404';


-- captura vendas por tipo de produto vendido no ecommerce
select
	pedido.numero,
	participante.nome,
	participante.celular,
	familia.nome,
	produto.nome
from pedido_documento as pedido
join sped_participante as participante
	on participante.id = pedido.participante_id
join sped_documento_item as item
	on item.pedido_id = pedido.id
join sped_produto as produto
	on produto.id = item.produto_id
join sped_produto_familia as familia
	on familia.id = produto.familia_id
where pedido.data_aprovacao between '2023-05-01' and '2023-05-31'
	and pedido.tipo = 'ecommerce'
	and familia.familia_superior_id = 4;


-- captura vendas por marca de produto vendido no ecommerce (busca por string)
select
	pedido.numero,
	produto.nome,
	produto.marca
from pedido_documento as pedido
join sped_participante as participante
	on participante.id = pedido.participante_id
join sped_documento_item as item
	on item.pedido_id = pedido.id
join sped_produto as produto
	on produto.id = item.produto_id
join sped_produto_familia as familia
	on familia.id = produto.familia_id
where pedido.data_aprovacao between '2023-05-01' and '2023-05-31'
	and pedido.tipo = 'ecommerce'
	and produto.marca = 'WANKE';


-- captura vendas por marca de produto vendido no ecommerce (busca por id)
select
	pedido.numero,
	marca.id,
	marca.nome
from pedido_documento as pedido
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
where pedido.data_aprovacao between '2023-05-01' and '2023-05-31'
	and pedido.tipo = 'ecommerce'
	and marca.id = '746';


select
	pedido.numero,
	marca.id,
	marca.nome
from pedido_documento as pedido
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
where pedido.data_aprovacao between '2023-05-01' and '2023-05-31'
	and pedido.tipo = 'ecommerce'
	and marca.id = '746';


marca = '746'
data_inicio = '2023-05-01',
data_final = '2023-05-31',
tipo_venda = "'ecommerce', 'venda'",
filtro_marca = f"and marca.id = '{marca}'"

sql = "select \
	pedido.numero, \
	pedido.vtex_id, \
	participante.nome, \
	participante.celular \
from pedido_documento as pedido \
join sped_participante as participante \
	on participante.id = pedido.participante_id \
join sped_documento_item as item \
	on item.pedido_id = pedido.id \
join sped_produto as produto \
	on produto.id = item.produto_id \
join sped_produto_familia as familia \
	on familia.id = produto.familia_id \
join sped_produto_marca as marca \
	on marca.id = produto.marca_id \
where pedido.data_aprovacao between {data_inicio} and {data_final} \
	and pedido.tipo in {tipo_venda} \
	{filtro_marca};"

sql = sql.format(
	data_inicio=data_inicio,
	data_final=data_final,
	tipo_venda=tipo_venda,
	filtro_marca=filtro_marca,
)
self.env.cr.execute(sql)
dados = self.env.cr.fetchall()

dados


-- executando sql
-- self.env.cr.execute(sql)

-- extraindo dados
-- dados = self.env.cr.fetchall()


select
    pedido.numero,
    pedido.vtex_id,
    participante.nome,
    participante.celular
from pedido_documento as pedido
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
where pedido.data_aprovacao between '2023-05-01' and '2023-05-31'
    and pedido.tipo in ('ecommerce', 'venda')
    and marca.id = '746';

select
    participante.nome,
    participante.celular

from pedido_documento as pedido
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

where pedido.data_aprovacao between '2023-01-01' and '2023-05-31'
    and pedido.tipo in ('ecommerce');