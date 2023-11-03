with dados as (
    select
        grupo.nome as grupo,

        case
            when documento.operacao_id in (2,4,5,106,168)
            then coalesce(item.vr_operacao, 0)
        end as  vr_total,

        case
            when documento.operacao_id in (2,4,5,106,168)
            then coalesce(item.quantidade, 0)
        end as  qtd_total,

        case
            when documento.operacao_id in (8 ,301 ,283)
            then coalesce(item.vr_operacao, 0)
        end as  valor_devolvido, 

        case
            when documento.operacao_id in (8 ,301 ,283)
            then coalesce(item.quantidade, 0)
        end as qtd_devolvido

    from
        sped_documento as documento
        join sped_documento_item as item
            on item.documento_id = documento.id
        join sped_produto as produto
            on item.produto_id = produto.id
        join sped_produto_familia as subgrupo
            on subgrupo.id = produto.familia_id
        join sped_produto_familia as grupo
            on grupo.id = subgrupo.familia_superior_id
        join sped_empresa as empresa_participante
            on documento.empresa_id = empresa_participante.id
        join sped_participante as empresa
            on empresa.id = empresa_participante.participante_id 

    where
        documento.data_emissao between  '2023-09-01' and '2023-09-01'
        and documento.operacao_id in (2,4,5,106,168,8 ,301 ,283)
        and documento.empresa_id = 376
        and documento.situacao_nfe = 'autorizada'
        and produto.active = True
        and produto.tipo = '00'
),

agrupado as (
    select
        dados.grupo as grupo,
        sum(coalesce(dados.qtd_total, 0)) as qtd_total,
        sum(coalesce(dados.vr_total, 0)) as vr_total,
        sum(coalesce(dados.qtd_devolvido, 0)) as qtd_devolvido,
        sum(coalesce(dados.valor_devolvido, 0)) as valor_devolvido

    from
        dados

    group by
        dados.grupo

    order by
        dados.grupo
)

select
    agrupado.*,
    -- Geral
    sum(agrupado.qtd_total) over geral as total_geral_qtd_total,
    sum(agrupado.vr_total) over geral as total_geral_vr_total,
    sum(agrupado.qtd_devolvido) over geral as total_geral_qtd_devolvido,
    sum(agrupado.valor_devolvido) over geral as total_geral_valor_devolvido

from
    agrupado

window
    geral as ()
