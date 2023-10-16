with dados as (

    select
        fornecedor.nome as fornecedor,
        pedido.data_financeiro as data_base,
        coalesce(pedido.vr_parcelamento, 0) as valor_contrato,
        coalesce(pedido.vr_juros_cobranca, 0) as juros,
        coalesce(pedido.vr_outros_creditos_cobranca, 0) as iof,
        pedido.condicao_pagamento_meses as prazo,
        lancamento.vr_saldo_total as saldo

    from
        pedido_documento as pedido
        join sped_participante as fornecedor
            on fornecedor.id = pedido.participante_id
        join finan_lancamento as lancamento
            on lancamento.pedido_id = pedido.id

    where
        pedido.tipo = 'parcelamento_a_pagar'
        and pedido.operacao_id  = 308
        and lancamento.situacao_divida in ('a_vencer',  'vence_hoje', 'quitado_parcialmente')
        and finaliza_pedido_cancelando is False

),

agrupado as (

    select
        dados.fornecedor,
        dados.data_base,
        dados.valor_contrato as valor_contrato,
        dados.juros as juros,
        dados.iof as iof,
        dados.prazo as prazo,
        sum(dados.saldo) as saldo

        from dados

        group by
            dados.fornecedor,
            dados.data_base,
            dados.valor_contrato,
            dados.juros,
            dados.iof,
            dados.prazo 

        order by
            dados.fornecedor

)

select
    agrupado.*,
    sum(agrupado.saldo) over geral as total_geral_saldo

from
    agrupado

window
    geral as ()