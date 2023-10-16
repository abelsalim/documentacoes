with dados as (

    select
        empresa.nome as empresa,
        nfe_saida.vr_nf as valor

    from sped_documento as nfe_saida
        join sped_empresa
            on sped_empresa.id = nfe_saida.empresa_id
        join sped_participante as empresa
            on empresa.id = sped_empresa.participante_id

    where nfe_saida.data_emissao between '2023-06-01' and '2023-06-30'
        and nfe_saida.situacao_nfe = 'autorizada'
        and nfe_saida.operacao_id = 6

),

agrupado as (

    select
        dados.empresa,
        sum(dados.valor) as valor_total

    from dados

    group by
        dados.empresa

    order by
        dados.empresa

)

select
    agrupado.*,
    sum(agrupado.valor_total) over geral as total_geral_valor_total

from agrupado

window
    geral as ()


-- Odoo

with dados as (

    select
        empresa.nome as empresa,
        nfe_saida.vr_nf as valor

    from sped_documento as nfe_saida
        join sped_empresa
            on sped_empresa.id = nfe_saida.empresa_id
        join sped_participante as empresa
            on empresa.id = sped_empresa.participante_id

    where nfe_saida.data_emissao between '{executa.data_emissao_inicial}' and '{executa.data_emissao_final}'
        and nfe_saida.situacao_nfe = 'autorizada'
        and nfe_saida.operacao_id = {executa.operacao_id.id}

),

agrupado as (

    select
        dados.empresa,
        sum(dados.valor) as valor_total

    from dados

    group by
        dados.empresa

    order by
        dados.empresa

)

select
    agrupado.empresa,
    agrupado.valor_total,
    sum(agrupado.valor_total) over geral as total_geral_valor_total

from agrupado

window
    geral as ()
