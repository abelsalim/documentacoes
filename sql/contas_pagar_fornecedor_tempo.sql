with dados as (
    select
        empresa.nome as empresa,
        lancamento.codigo as codigo,
        documento.nome as documento,
        lancamento.numero as numero,
        conta.codigo as conta,
        participante.nome as participante,
        lancamento.data_vencimento as data_vencimento,
        coalesce(lancamento.vr_documento, 0) as vr_documento,
        coalesce(lancamento.vr_pago_documento, 0) as vr_pago_documento,
        coalesce(lancamento.vr_saldo, 0) as vr_saldo

    from
        finan_lancamento as lancamento
        join finan_conta as conta
            on conta.id = lancamento.conta_id
        join finan_documento as documento
            on documento.id = lancamento.documento_id
        join sped_participante as participante
            on participante.id = lancamento.participante_id
        join sped_empresa
            on sped_empresa.id = lancamento.empresa_id
        join sped_participante as empresa
            on empresa.id = sped_empresa.participante_id

    where
        lancamento.data_vencimento between '2023-06-01' and '2023-06-30'
        and lancamento.data_pagamento between '2023-06-01' and '2023-06-30'
        and lancamento.data_documento < '2023-06-01'
        and lancamento.tipo = 'a_pagar'
        and lancamento.empresa_id = 375

    order by
        lancamento.data_vencimento,
        empresa.nome,
        participante.nome,
        lancamento.numero
)

select
    dados.*,
    -- Geral
    sum(dados.vr_documento) over geral as total_geral_vr_documento,
    sum(dados.vr_pago_documento) over geral as total_geral_vr_pago_documento,
    sum(dados.vr_saldo) over geral as total_geral_vr_saldo,
    -- Grupo 1
    sum(dados.vr_documento) over grupo_1 as grupo_1_vr_documento,
    sum(dados.vr_pago_documento) over grupo_1 as grupo_1_vr_pago_documento,
    sum(dados.vr_saldo) over grupo_1 as grupo_1_vr_saldo,
    -- Grupo 2
    sum(dados.vr_documento) over grupo_2 as grupo_2_vr_documento,
    sum(dados.vr_pago_documento) over grupo_2 as grupo_2_vr_pago_documento,
    sum(dados.vr_saldo) over grupo_2 as grupo_2_vr_saldo,
    -- Grupo 3
    sum(dados.vr_documento) over grupo_3 as grupo_3_vr_documento,
    sum(dados.vr_pago_documento) over grupo_3 as grupo_3_vr_pago_documento,
    sum(dados.vr_saldo) over grupo_3 as grupo_3_vr_saldo

from
    dados

window
    geral as (),
    grupo_1 as (partition by dados.data_vencimento),
    grupo_2 as (partition by dados.data_vencimento, dados.empresa, dados.participante),
    grupo_3 as (partition by dados.data_vencimento, dados.empresa, dados.participante)
