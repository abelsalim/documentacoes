select
    pedido.id

from
    pedido_documento as pedido

where
    pedido.data_aprovacao is not null
    and age(current_date, pedido.data_aprovacao) > interval '35 days'
    and pedido.tipo = 'cobranca_a_receber'
    and pedido.etapa_id in (304,305)
