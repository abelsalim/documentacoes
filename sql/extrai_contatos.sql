select
    participante.nome,
    case
        --when length(coalesce(participante.celular, 0)) = 15
        when coalesce(participante.celular, 0) != null
            then participante.celular
        end as celular

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