with dados as (
    select
        empresa.nome as empresa,
        cobrador.nome as cobrador,
        cr.numero as cr,
        recebimento.codigo as recebimento,
        a_receber.numero as contrato,
        cliente.nome as cliente,
        cr.data_aprovacao as data_cobranca,
        a_receber.data_vencimento as data_vencimento,
        (recebimento.data_pagamento - a_receber.data_vencimento)::integer as atraso,
        recebimento.vr_pago_documento as principal,
        recebimento.vr_pago_juros as juros,
        recebimento.vr_total as total,
        recebimento.valor_comissao_cobrador as comissao

    from
        finan_lancamento as recebimento
        join finan_lancamento as a_receber
            on a_receber.id = recebimento.divida_unica_id
        join sped_participante as cobrador
            on cobrador.id = recebimento.cobrador_id
        join sped_participante as cliente
            on cliente.id = a_receber.participante_id
        join finan_lancamento_cobranca_divida as relacionamento_cr
            on relacionamento_cr.divida_id = a_receber.id
        join pedido_documento as cr
            on cr.id = relacionamento_cr.cobranca_id
        join sped_empresa
            on sped_empresa.id = a_receber.empresa_id
        join sped_participante as empresa
            on empresa.id = sped_empresa.participante_id

    where
        recebimento.data_pagamento between '2024-01-01' and '2024-01-19'
        and cr.data_orcamento > '2024-01-15'
        and recebimento.tipo = 'recebimento'
        and recebimento.valor_comissao_cobrador is not null
        and recebimento.valor_comissao_cobrador > 0
        and cr.etapa_id in (304,305)

    order by
        cobrador.cnpj_cpf
)

select
    dados.*,
    -- Geral
    sum(dados.comissao) over geral as total_geral_comissao

from
    dados

window
    geral as ()
