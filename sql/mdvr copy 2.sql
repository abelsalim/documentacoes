with dados_vendas as (
    select
        pedido.empresa_id as empresa,
        case
            when pagamento.forma_pagamento_id = 1
            then coalesce(pagamento.valor, 0)
            else 0
        end as venda_dinheiro,

        case
            when pagamento.forma_pagamento_id in (18, 58)
            then coalesce(pagamento.valor, 0)
            else 0
        end as venda_pix,

        case
            when pagamento.forma_pagamento_id = 6
            then coalesce(pagamento.valor, 0)
            else 0
        end as venda_boleto,

        case
            when pagamento.forma_pagamento_id = 4
            then coalesce(pagamento.valor, 0)
            else 0
        end as venda_carne,

        case
            when pagamento.forma_pagamento_id in (10, 11)
            then coalesce(pagamento.valor, 0)
            else 0
        end as venda_cheque,

        case
            when pagamento.forma_pagamento_id in (56, 51, 2, 54)
            then coalesce(pagamento.valor, 0)
            else 0
        end as venda_credito,

        case
            when pagamento.forma_pagamento_id in (57, 53, 3, 55)
            then coalesce(pagamento.valor, 0)
            else 0
        end as venda_debito,

        case
            when pagamento.forma_pagamento_id = 5
            then coalesce(pagamento.valor, 0)
            else 0
        end as venda_financeira,

        case
            when pagamento.forma_pagamento_id = 52
            then coalesce(pagamento.valor, 0)
            else 0
        end as venda_pagamento_credito,

        case
            when pagamento.forma_pagamento_id = 12
            then coalesce(pagamento.valor, 0)
            else 0
        end as venda_transferencia_bancaria,

        case
            when pagamento.forma_pagamento_id = 7
            then coalesce(pagamento.valor, 0)
            else 0
        end as venda_vale_compra

    from
        pedido_documento as pedido
        join pedido_pagamento as pagamento
            on pagamento.pedido_id = pedido.id

    where
        pedido.data_aprovacao between '2023-09-01' and '2023-09-30'
        and pedido.tipo = 'venda'
        and pedido.empresa_id = 366
        and pedido.finaliza_pedido_cancelando = False
),

agrupado_vendas as (
    select
        dados_vendas.empresa as empresa,
        round(sum(dados_vendas.venda_dinheiro), 2) as venda_dinheiro,
        round(sum(dados_vendas.venda_pix), 2) as venda_pix,
        round(sum(dados_vendas.venda_boleto), 2) as venda_boleto,
        round(sum(dados_vendas.venda_carne), 2) as venda_carne,
        round(sum(dados_vendas.venda_cheque), 2) as venda_cheque,
        round(sum(dados_vendas.venda_credito), 2) as venda_credito,
        round(sum(dados_vendas.venda_debito), 2) as venda_debito,
        round(sum(dados_vendas.venda_financeira), 2) as venda_financeira,
        round(sum(dados_vendas.venda_pagamento_credito), 2) as venda_pagamento_credito,
        round(sum(dados_vendas.venda_transferencia_bancaria), 2) as venda_transferencia_bancaria,
        round(sum(dados_vendas.venda_vale_compra), 2) as venda_vale_compra

    from
        dados_vendas

    group by
        dados_vendas.empresa
)

select
    -- dados vendas
    sum(agrupado_vendas.venda_dinheiro) as venda_dinheiro,
    sum(agrupado_vendas.venda_pix) as venda_pix,
    sum(agrupado_vendas.venda_boleto) as venda_boleto,
    sum(agrupado_vendas.venda_carne) as venda_carne,
    sum(agrupado_vendas.venda_cheque) as venda_cheque,
    sum(agrupado_vendas.venda_credito) as venda_credito,
    sum(agrupado_vendas.venda_debito) as venda_debito,
    sum(agrupado_vendas.venda_financeira) as venda_financeira,
    sum(agrupado_vendas.venda_pagamento_credito) as venda_pagamento_credito,
    sum(agrupado_vendas.venda_transferencia_bancaria) as venda_transferencia_bancaria,
    sum(agrupado_vendas.venda_vale_compra) as venda_vale_compra

from
    agrupado_vendas
