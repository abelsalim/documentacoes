with dados as (
    select
        grupo.nome as grupo,
        produto.codigo as codigo,
        produto.nome as produto,
        saldo_hoje.saldo as saldo

    from
        estoque_saldo_hoje as saldo_hoje
        left join estoque_local as estoque
            on estoque.id = saldo_hoje.local_id
        left join sped_produto as produto
            on produto.id = saldo_hoje.produto_id
        join sped_produto_familia as subgrupo
            on subgrupo.id = produto.familia_id
        join sped_produto_familia as grupo
            on grupo.id = subgrupo.familia_superior_id

    where
        (saldo_hoje.saldo > 0 and saldo_hoje.saldo is not null)
        -- É 'Disponível para venda'?
        and estoque.exibe_saldo_venda = 'True'
        -- Disponível venda: campos sales I, Sobral I, Barão, Tianguá I,
        -- Asa Branca, trânsito
        and estoque.id not in (145, 156, 202, 159, 721)
        -- Apenas produtos fora de linha
        and produto.fora_linha = True
        -- Se existe familia superior
        and subgrupo.familia_superior_id is not null
        -- produtos de revenda
        and produto.tipo = '00'
        -- Se familia superior igual ao valor repassado
        -- and grupo.id in (2)
),

agrupado as (
    select
        dados.grupo as grupo,
        dados.codigo as codigo,
        dados.produto as produto,
        sum(dados.saldo) as saldo

    from
        dados

    group by
        dados.grupo,
        dados.codigo,
        dados.produto

    order by
        dados.grupo
)

select
    agrupado.*,
    -- Geral
    sum(agrupado.saldo) over geral as total_geral_saldo,
    -- Grupo 1
    sum(agrupado.saldo) over grupo_1 as grupo_1_saldo

from
    agrupado

window
    geral as (),
    grupo_1 as (partition by agrupado.grupo)
