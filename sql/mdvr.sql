with dados_vendas as (
    select
        pedido.empresa_id as empresa,
        case
            when pagamento.forma_pagamento_id = 1
            then pagamento.valor
            else 0
        end as venda_dinheiro,

        case
            when pagamento.forma_pagamento_id in (18, 58)
            then pagamento.valor
            else 0
        end as venda_pix,

        case
            when pagamento.forma_pagamento_id = 6
            then pagamento.valor
            else 0
        end as venda_boleto,

        case
            when pagamento.forma_pagamento_id = 4
            then pagamento.valor
            else 0
        end as venda_carne,

        case
            when pagamento.forma_pagamento_id in (10, 11)
            then pagamento.valor
            else 0
        end as venda_cheque,

        case
            when pagamento.forma_pagamento_id in (56, 51, 2, 54)
            then pagamento.valor
            else 0
        end as venda_credito,

        case
            when pagamento.forma_pagamento_id in (57, 53, 3, 55)
            then pagamento.valor
            else 0
        end as venda_debito,

        case
            when pagamento.forma_pagamento_id = 5
            then pagamento.valor
            else 0
        end as venda_financeira,

        case
            when pagamento.forma_pagamento_id = 52
            then pagamento.valor
            else 0
        end as venda_pagamento_credito,

        case
            when pagamento.forma_pagamento_id = 12
            then pagamento.valor
            else 0
        end as venda_transferencia_bancaria,

        case
            when pagamento.forma_pagamento_id = 7
            then pagamento.valor
            else 0
        end as venda_vale_compra

    from
        pedido_documento as pedido
        join pedido_pagamento as pagamento
            on pagamento.pedido_id = pedido.id

    where
        pedido.data_aprovacao between '2023-07-26' and '2023-07-26'
        and pedido.tipo = 'venda'
        and pedido.empresa_id = 409
        and pedido.finaliza_pedido_cancelando = False
),

dados_recebimento as (
    select
        lancamento.empresa_id as empresa,
        case
            when lancamento.forma_pagamento_id = 1
            then lancamento.vr_pago_documento
            else 0
        end as recebimento_dinheiro,

        case
            when lancamento.forma_pagamento_id in (18, 58)
            then lancamento.vr_pago_documento
            else 0
        end as recebimento_pix,

        case
            when lancamento.forma_pagamento_id = 6
            then lancamento.vr_pago_documento
            else 0
        end as recebimento_boleto,

        case
            when lancamento.forma_pagamento_id = 4
            then lancamento.vr_pago_documento
            else 0
        end as recebimento_carne,

        case
            when lancamento.forma_pagamento_id in (10, 11)
            then lancamento.vr_pago_documento
            else 0
        end as recebimento_cheque,

        case
            when lancamento.forma_pagamento_id in (56, 51, 2, 54)
            then lancamento.vr_pago_documento
            else 0
        end as recebimento_credito,

        case
            when lancamento.forma_pagamento_id in (57, 53, 3, 55)
            then lancamento.vr_pago_documento
            else 0
        end as recebimento_debito,

        case
            when lancamento.forma_pagamento_id = 5
            then lancamento.vr_pago_documento
            else 0
        end as recebimento_financeira,

        case
            when lancamento.forma_pagamento_id = 52
            then lancamento.vr_pago_documento
            else 0
        end as recebimento_pagamento_credito,

        case
            when lancamento.forma_pagamento_id = 12
            then lancamento.vr_pago_documento
            else 0
        end as recebimento_transferencia_bancaria,

        case
            when lancamento.forma_pagamento_id = 7
            then lancamento.vr_pago_documento
            else 0
        end as recebimento_vale_compra

    from
        finan_lancamento as lancamento

    where
        lancamento.data_pagamento between '2023-10-08' and '2023-10-09'
        and lancamento.tipo = 'recebimento'
        and lancamento.empresa_id = 409
        and lancamento.situacao_divida in ('quitado', 'quitado_parcialmente')
),

agrupado_vendas as (
    select
        dados_vendas.empresa as empresa,
        round(sum(coalesce(dados_vendas.venda_dinheiro, 0)), 2) as venda_dinheiro,
        round(sum(coalesce(dados_vendas.venda_pix, 0)), 2) as venda_pix,
        round(sum(coalesce(dados_vendas.venda_boleto, 0)), 2) as venda_boleto,
        round(sum(coalesce(dados_vendas.venda_carne, 0)), 2) as venda_carne,
        round(sum(coalesce(dados_vendas.venda_cheque, 0)), 2) as venda_cheque,
        round(sum(coalesce(dados_vendas.venda_credito, 0)), 2) as venda_credito,
        round(sum(coalesce(dados_vendas.venda_debito, 0)), 2) as venda_debito,
        round(sum(coalesce(dados_vendas.venda_financeira, 0)), 2) as venda_financeira,
        round(sum(coalesce(dados_vendas.venda_pagamento_credito, 0)), 2) as venda_pagamento_credito,
        round(sum(coalesce(dados_vendas.venda_transferencia_bancaria, 0)), 2) as venda_transferencia_bancaria,
        round(sum(coalesce(dados_vendas.venda_vale_compra, 0)), 2) as venda_vale_compra

    from
        dados_vendas

    group by
        dados_vendas.empresa
),

agrupado_recebimento as (
    select
        dados_recebimento.empresa as empresa,
        round(sum(coalesce(dados_recebimento.recebimento_dinheiro, 0)), 2) as recebimento_dinheiro,
        round(sum(coalesce(dados_recebimento.recebimento_pix, 0)), 2) as recebimento_pix,
        round(sum(coalesce(dados_recebimento.recebimento_boleto, 0)), 2) as recebimento_boleto,
        round(sum(coalesce(dados_recebimento.recebimento_carne, 0)), 2) as recebimento_carne,
        round(sum(coalesce(dados_recebimento.recebimento_cheque, 0)), 2) as recebimento_cheque,
        round(sum(coalesce(dados_recebimento.recebimento_credito, 0)), 2) as recebimento_credito,
        round(sum(coalesce(dados_recebimento.recebimento_debito, 0)), 2) as recebimento_debito,
        round(sum(coalesce(dados_recebimento.recebimento_financeira, 0)), 2) as recebimento_financeira,
        round(sum(coalesce(dados_recebimento.recebimento_pagamento_credito, 0)), 2) as recebimento_pagamento_credito,
        round(sum(coalesce(dados_recebimento.recebimento_transferencia_bancaria, 0)), 2) as recebimento_transferencia_bancaria,
        round(sum(coalesce(dados_recebimento.recebimento_vale_compra, 0)), 2) as recebimento_vale_compra

    from
        dados_recebimento

    group by
        dados_recebimento.empresa
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
    -- dados recebimento
    sum(agrupado_recebimento.recebimento_dinheiro) as recebimento_dinheiro,
    sum(agrupado_recebimento.recebimento_pix) as recebimento_pix,
    sum(agrupado_recebimento.recebimento_boleto) as recebimento_boleto,
    sum(agrupado_recebimento.recebimento_carne) as recebimento_carne,
    sum(agrupado_recebimento.recebimento_cheque) as recebimento_cheque,
    sum(agrupado_recebimento.recebimento_credito) as recebimento_credito,
    sum(agrupado_recebimento.recebimento_debito) as recebimento_debito,
    sum(agrupado_recebimento.recebimento_financeira) as recebimento_financeira,
    sum(agrupado_recebimento.recebimento_pagamento_credito) as recebimento_pagamento_credito,
    sum(agrupado_recebimento.recebimento_transferencia_bancaria) as recebimento_transferencia_bancaria,
    sum(agrupado_recebimento.recebimento_vale_compra) as recebimento_vale_compra

from
    agrupado_vendas
    join agrupado_recebimento
        on agrupado_recebimento.empresa = agrupado_vendas.empresa
