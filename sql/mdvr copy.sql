with dados_vendas as (
    select
        documento.empresa_id as empresa,
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
        end as venda_vale_compra,

        case
            when pagamento.forma_pagamento_id not in (1, 18, 58, 6, 4, 10, 11, 56, 51, 2, 54, 57, 53, 3, 55, 5, 52, 12, 7)
            then coalesce(pagamento.valor, 0)
            else 0
        end as venda_outros,

        0 as recebimento_dinheiro,
        0 as recebimento_juros,
        0 as recebimento_desconto

    from
        sped_documento as documento
        join sped_documento_pagamento as pagamento
            on pagamento.documento_id = documento.id
        join sped_operacao as operacao
            on operacao.id = documento.operacao_id

    where
        documento.data_emissao between '2023-09-01' and '2023-09-30'
        and documento.empresa_id = 409
        and operacao.eh_operacao_venda = True
        and documento.situacao_fiscal = '00'
),

dados_recebimento as (
    select
        lancamento.empresa_id as empresa,
        0 as venda_dinheiro,
        0 as venda_pix,
        0 as venda_boleto,
        0 as venda_carne,
        0 as venda_cheque,
        0 as venda_credito,
        0 as venda_debito,
        0 as venda_financeira,
        0 as venda_pagamento_credito,
        0 as venda_transferencia_bancaria,
        0 as venda_vale_compra,
        0 as venda_outros,

        case
            when lancamento.forma_pagamento_id = 1
            then coalesce(lancamento.vr_pago_documento, 0)
            else 0
        end as recebimento_dinheiro,

        case
            when lancamento.forma_pagamento_id = 1
            then coalesce(lancamento.vr_pago_juros, 0)
            else 0
        end as recebimento_juros,

        case
            when lancamento.forma_pagamento_id = 1
            then coalesce(lancamento.vr_pago_desconto, 0)
            else 0
        end as recebimento_desconto

    from
        finan_lancamento as lancamento

    where
        lancamento.data_pagamento between '2023-09-01' and '2023-09-30'
        and lancamento.tipo = 'recebimento'
        and lancamento.empresa_id = 409
        and lancamento.situacao_divida in ('quitado', 'quitado_parcialmente')
),

agrupado as (
    select * from dados_vendas
    union all
    select * from dados_recebimento
)

select
    -- dados vendas
    sum(agrupado.venda_dinheiro) as venda_dinheiro,
    sum(agrupado.venda_pix) as venda_pix,
    sum(agrupado.venda_boleto) as venda_boleto,
    sum(agrupado.venda_carne) as venda_carne,
    sum(agrupado.venda_cheque) as venda_cheque,
    sum(agrupado.venda_credito) as venda_credito,
    sum(agrupado.venda_debito) as venda_debito,
    sum(agrupado.venda_financeira) as venda_financeira,
    sum(agrupado.venda_pagamento_credito) as venda_pagamento_credito,
    sum(agrupado.venda_transferencia_bancaria) as venda_transferencia_bancaria,
    sum(agrupado.venda_vale_compra) as venda_vale_compra,
    sum(agrupado.venda_outros) as venda_outros,ja
    -- dados recebimento
    sum(agrupado.recebimento_dinheiro) as recebimento_dinheiro,
    sum(agrupado.recebimento_juros) as recebimento_juros,
    sum(agrupado.recebimento_desconto) as recebimento_desconto

from
    agrupado
