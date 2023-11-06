with dados as (
    select
        empresa.nome as empresa,
        participante.cnpj_cpf as cnpj_cpf,
        participante.nome as participante,
        coalesce(participante.celular, 'Sem telefone cadastrado') as celular,
        coalesce(left(lancamento.numero, position('/' in lancamento.numero) -1), lancamento.codigo) as contrato,
        coalesce(avalista.nome, '') as avalista

    from
        finan_lancamento as lancamento
        join sped_participante as participante
            on participante.id = lancamento.participante_id
        join sped_empresa
            on sped_empresa.id = lancamento.empresa_id
        join sped_participante as empresa
            on  empresa.id = sped_empresa.participante_id
        left join sped_participante as avalista
            on avalista.id = participante.avalista_id

    where
        lancamento.tipo = 'a_receber'
        and participante.cliente_negativado_spc = True
        and lancamento.situacao_divida not in ('provisorio', 'a_vencer', 'vence_hoje', 'quitado', 'baixado')
        and lancamento.empresa_id = 360
),

agrupado as (
    select
        dados.empresa as empresa,
        dados.cnpj_cpf as cnpj_cpf,
        dados.participante as participante,
        dados.celular as celular,
        dados.contrato as contrato,
        dados.avalista as avalista

    from
        dados

    group by
        dados.empresa,
        dados.cnpj_cpf,
        dados.participante,
        dados.celular,
        dados.contrato,
        dados.avalista

    order by
        dados.empresa,
        dados.participante
)

select
    agrupado.*

from
    agrupado
