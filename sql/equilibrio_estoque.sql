with dados as (
    select
        produto.codigo as codigo,
        produto.nome as produto,
        extrato.quantidade as quantidade

    from
        estoque_extrato as extrato
        left join sped_produto as produto
            on produto.id = extrato.produto_id
        join sped_produto_familia as subgrupo
            on subgrupo.id = produto.familia_id
        join sped_produto_familia as grupo
            on grupo.id = subgrupo.familia_superior_id


    where
        extrato.data between '2023-07-01' and '2023-07-31'
        and produto.codigo = '2025'
        -- Se existe familia superior
        and subgrupo.familia_superior_id is not null
        -- produtos de revenda
        and produto.tipo = '00'
),

agrupado as (
    select
        dados.codigo as codigo,
        dados.produto as produto,
        sum(coalesce(dados.quantidade, 0)) as quantidade

    from
        dados

    group by
        dados.codigo,
        dados.produto
)

select
    agrupado.*

from
    agrupado
