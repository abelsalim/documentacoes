with dados as (
    select
        empresa_venda.nome as empresa,
        forma_pagament.nome as forma_pagamento,
        empresa_beneficiaria.nome as empresa_divida,
        divida.codigo as codigo,
        divida.numero as numero,
        divida.data_documento,
        divida.data_vencimento_util as data_vencimento,
        conta.nome as conta,
        cliente.razao_social as cliente,
        cliente.cnpj_cpf as cnpj_cpf,
        coalesce(pagamento_divida.vr_documento, 0) as vr_documento,
        coalesce(pagamento_divida.vr_juros, 0) as vr_juros,
        coalesce(pagamento_divida.vr_desconto, 0) as vr_desconto,
        coalesce(pagamento_divida.vr_total, 0) as vr_total,
        coalesce(pagamento_divida.vr_multa, 0) as vr_multa

    from
        finan_lancamento pagamento
        left join finan_pagamento_divida as pagamento_divida
            on pagamento_divida.pagamento_id = pagamento.id
        left join finan_lancamento as divida
            on divida.id = pagamento_divida.divida_id
        -- Dados do pagamento
        join finan_forma_pagamento as forma_pagament
            on forma_pagament.id = pagamento.forma_pagamento_id
        join finan_conta as conta
            on conta.id = pagamento.conta_id
        -- Empresa que recebeu o pagamento
        join sped_empresa as sped_empresa_venda
            on sped_empresa_venda.id = pagamento.empresa_id
        join sped_participante as empresa_venda
            on empresa_venda.id = sped_empresa_venda.participante_id
        -- Empresa onde a dívida foi contraída
        join sped_empresa as sped_empresa_beneficiaria
            on sped_empresa_beneficiaria.id = divida.empresa_id
        join sped_participante as empresa_beneficiaria
            on empresa_beneficiaria.id = sped_empresa_beneficiaria.participante_id
        -- Cliente
        join sped_participante as cliente
            on cliente.id = pagamento.participante_id

    where
        pagamento.provisorio is False
        and pagamento.tipo = 'recebimento'
        {where_data_pagamento}
        {where_empresa}
        {where_participante}
        {where_conta}
        {where_forma_pagamento}

    order by
        empresa_venda.nome,
        forma_pagament.nome,
        cliente.razao_social,
        divida.data_vencimento_util
)

select
    dados.*,

    sum(coalesce(dados.vr_documento, 0)) over(geral) as total_geral_vr_documento,
    sum(coalesce(dados.vr_documento, 0)) over(grupo_1) as grupo_1_vr_documento,
    sum(coalesce(dados.vr_documento, 0)) over(grupo_2) as grupo_2_vr_documento,

    sum(coalesce(dados.vr_juros, 0)) over(geral) as total_geral_vr_juros,
    sum(coalesce(dados.vr_juros, 0)) over(grupo_1) as grupo_1_vr_juros,
    sum(coalesce(dados.vr_juros, 0)) over(grupo_2) as grupo_2_vr_juros,

    sum(coalesce(dados.vr_multa, 0)) over(geral) as total_geral_vr_multa,
    sum(coalesce(dados.vr_multa, 0)) over(grupo_1) as grupo_1_vr_multa,
    sum(coalesce(dados.vr_multa, 0)) over(grupo_2) as grupo_2_vr_multa,

    sum(coalesce(dados.vr_desconto, 0)) over(geral) as total_geral_vr_desconto,
    sum(coalesce(dados.vr_desconto, 0)) over(grupo_1) as grupo_1_vr_desconto,
    sum(coalesce(dados.vr_desconto, 0)) over(grupo_2) as grupo_2_vr_desconto,
    
    sum(coalesce(dados.vr_total, 0)) over(geral) as total_geral_vr_total,
    sum(coalesce(dados.vr_total, 0)) over(grupo_1) as grupo_1_vr_total,
    sum(coalesce(dados.vr_total, 0)) over(grupo_2) as grupo_2_vr_total

from
    dados

window
    geral as (),
    grupo_1 as (partition by dados.empresa),
    grupo_2 as (partition by dados.empresa, dados.forma_pagamento);