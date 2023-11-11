with dados as (
    select
        documento.data_apuracao as data_entrada,
        documento.data_fato_gerador as fato_gerador,
        documento.numero as nota,
        produto.codigo || ' - ' || produto.nome as produto,
        item.codigo_ajuste_apuracao_icms_proprio as ajuste_icms,
        item.vr_ajuste_apuracao_icms_proprio as vr_icms,
        item.codigo_ajuste_apuracao_icms_st as ajuste_icms_st,
        item.vr_ajuste_apuracao_icms_st as vr_icms_st,
        empresa_participante.nome as empresa,
        coalesce(cfop.codigo, '') as cfop,
        item.cst_icms as cst

    from sped_documento_item as item
        join sped_documento as documento
        join sped_produto as produto
            on produto.id = item.produto_id
        join sped_empresa as empresa
            on empresa.id = documento.empresa_id
        join sped_participante as empresa_participante
            on empresa_participante.id = empresa.participante_id
        join sped_cfop as cfop
            on cfop.id = item.cfop_id

    where
        documento.data_apuracao between '2023-10-11' and '2023-10-11'
        and documento.simulacao = False
        and documento.situacao_fiscal in ('00', '01', '06', '07', '08')
        and (item.vr_ajuste_apuracao_icms_proprio > 0 or item.vr_ajuste_apuracao_icms_st > 0)
        and empresa.id = 393

    order by
        documento.data_apuracao

)

select
    dados.*,
    -- Geral
    sum(dados.vr_icms) over geral as total_geral_vr_icms,
    sum(dados.vr_icms_st) over geral as total_geral_vr_icms_st,
    -- Grupo 1
    sum(dados.vr_icms) over grupo_1 as grupo_1_vr_icms,
    sum(dados.vr_icms_st) over grupo_1 as grupo_1_vr_icms_st

from
    dados

window
    geral as (),
    grupo_1 as (partition by dados.empresa order by dados.empresa)