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
    lancamento.data_extrato between '2023-06-01' and '2023-06-30'
    and lancamento.provisorio is False
    and lancamento.tipo = 'a_pagar'
    and lancamento.conta_id = 667
    and lancamento.centro_resultado_id = 11

order by
    lancamento.data_vencimento_util,
    participante.razao_social,
    forma_pagamento.nome;
