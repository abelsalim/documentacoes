with dados as (
    select
        centro_resultado.nome as empresa,
        participante.razao_social as participante,
        lancamento.codigo as codigo,
        lancamento.numero as numero,
        lancamento.data_vencimento_util as data_vencimento,
        conta.nome as conta,
        lancamento.historico as historico,
        coalesce(pagamento.vr_documento, 0) as vr_documento,
        coalesce(pagamento.vr_juros, 0) as vr_juros,
        coalesce(pagamento.vr_desconto, 0) as vr_desconto,
        coalesce(pagamento.vr_total, 0) as vr_total

    from
        finan_lancamento as lancamento
        join finan_pagamento_divida as pagamento
            on pagamento.divida_id = lancamento.id
        join finan_centro_resultado as centro_resultado
            on centro_resultado.id = lancamento.centro_resultado_id
        join finan_forma_pagamento as forma_pagamento
            on forma_pagamento.id = lancamento.forma_pagamento_id
        join finan_conta as conta
            on conta.id = lancamento.conta_id
        join sped_empresa as sped_emp
            on sped_emp.id = lancamento.empresa_id
        join sped_participante as empresa
            on empresa.id = sped_emp.participante_id
        join sped_participante as participante
            on participante.id = lancamento.participante_id

    where
        lancamento.data_extrato between '{executa.data_pagamento_inicial}' and '{executa.data_pagamento_final}'
        and lancamento.provisorio is False
        and lancamento.tipo = 'a_pagar'
        {where_centro_resultado}
        {where_conta}

    order by
        lancamento.conta_id
)

select
    dados.*,
    -- Geral
    sum(dados.vr_documento) over geral as total_geral_vr_documento,
    sum(dados.vr_juros) over geral as total_geral_vr_juros,
    sum(dados.vr_desconto) over geral as total_geral_vr_desconto,
    sum(dados.vr_total) over geral as total_geral_vr_total,
    -- Grupo 01
    sum(dados.vr_documento) over grupo_1 as grupo_1_vr_documento,
    sum(dados.vr_juros) over grupo_1 as grupo_1_vr_juros,
    sum(dados.vr_desconto) over grupo_1 as grupo_1_vr_desconto,
    sum(dados.vr_total) over grupo_1 as grupo_1_vr_total

from
    dados

window
    geral as (),
    grupo_1 as (partition by dados.empresa)
