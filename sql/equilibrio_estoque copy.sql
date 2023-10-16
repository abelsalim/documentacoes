with dados as (
    select
        empresa.nome as empresa,
        produto.codigo as codigo,
        produto.nome as produto,
        grupo.nome as grupo,
        (
            select
                saldo_hoje.saldo
            from
                estoque_saldo_hoje as saldo_hoje
            where
                saldo_hoje.local_id = extrato.local_id
                and saldo_hoje.produto_id = produto.id
        ) as saldo,
        extrato.quantidade as vendido

    from
        estoque_extrato as extrato
        left join estoque_local as estoque
            on estoque.id = extrato.local_id
        left join sped_produto as produto
            on produto.id = extrato.produto_id
        join sped_produto_familia as subgrupo
            on subgrupo.id = produto.familia_id
        join sped_produto_familia as grupo
            on grupo.id = subgrupo.familia_superior_id
        join sped_participante as empresa
            on empresa.id = estoque.proprietario_local_id

    where
        extrato.data between '2023-07-01' and '2023-07-31'
        -- É 'Disponível para venda'?
        and estoque.exibe_saldo_venda = 'True'
        -- Apenas tal produto
        -- and produto.codigo = '2025'
        -- Se existe familia superior
        and subgrupo.familia_superior_id is not null
        -- produtos de revenda
        and produto.tipo = '00'
        -- Filial selecionada
        and estoque.proprietario_local_id = 698
        -- Apenas produtos vendidos
        and extrato.quantidade < 0
        -- Se familia superior igual ao valor repassado
        and grupo.id in (2)
),

agrupado as (
    select
        dados.empresa as empresa,
        dados.codigo as codigo,
        dados.produto as produto,
        dados.grupo as grupo,
        round(coalesce(dados.saldo, 0), 1) as saldo,
        round(count(coalesce(dados.vendido, 0)), 1) as vendido

    from
        dados

    group by
        dados.empresa,
        dados.codigo,
        dados.produto,
        dados.grupo,
        dados.saldo

    order by
        dados.produto

)

select
    agrupado.*,
    case
        when (agrupado.saldo - agrupado.vendido) > 0
        then round(
            agrupado.vendido / (agrupado.saldo - agrupado.vendido), 1
        )
        else 0.0
    end as cobertura

from
    agrupado

window
    geral as (partition by agrupado.grupo)

colunas = [
    Coluna(titulo='Filial', campo='empresa', largura=60),
    Coluna(titulo='Código', campo='codigo', largura=16),
    Coluna(titulo='Produto', campo='produto', largura=100),
    Coluna(titulo='Saldo', campo='saldo', tipo='CC', largura=30),
    Coluna(titulo='Vendido', campo='vendido', tipo='CC', largura=30),
    Coluna(titulo='Cobertura', campo='cobertura', tipo='CC', largura=30)
]

grupos = [
    Grupo(titulo='grupo', nome='grupo', campo='grupo'),
]