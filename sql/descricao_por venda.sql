with dados as (
    select
        produto.codigo as codigo,
        produto.nome as nome,
        produto.descricao_vendas as descricao,
        grupo.nome as grupo

    from
        sped_produto as produto
        join sped_produto_familia as subgrupo
            on subgrupo.id = produto.familia_id
        join sped_produto_familia as grupo
            on grupo.id = subgrupo.familia_superior_id

    where
        -- Se existe familia superior
        subgrupo.familia_superior_id is not null
        -- Se produto ativo
        and produto.active = True
        -- Se familia superior igual ao valor repassado
        and grupo.id in (8)
        -- Se familia igual ao valor repassado
        and subgrupo.id in (300, 110)
),

agrupado as (
    select
        dados.codigo as codigo,
        dados.nome as nome,
        dados.grupo as grupo,
        coalesce(dados.descricao, '') as descricao,
        row_number() over(order by dados.nome) as numero

    from
        dados

    group by
        dados.codigo,
        dados.nome,
        dados.grupo,
        dados.descricao

    order by
        dados.grupo
)

select
    agrupado.*

from
    agrupado

window
    geral as (partition by agrupado.grupo order by agrupado.grupo)
