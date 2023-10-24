with dados as (
    select
        row_number() over (
            partition by saldo.local_id, produto.id
            order by saldo.data desc
        ) as numero,
        estoque.proprietario_local_id as proprietario_local_id,
        saldo.saldo as estoque,
        produto.vr_custo_venda as vr_custo_venda,
        produto.preco_venda as preco_venda,
        produto.vr_custo_ultima_compra as vr_custo_ultima_compra

    from
        estoque_saldo as saldo
        -- define local de estoque
        join estoque_local as estoque
            on estoque.id = saldo.local_id
        -- define o produto
        join sped_produto as produto
            on produto.id = saldo.produto_id

    where
        saldo.saldo is not null
        -- data é menor ou igual a data repassada
        and saldo.data <= '2023-10-23'
        -- É 'Disponível para venda'?
        and estoque.exibe_saldo_venda = True
        -- Disponível venda: campos sales I, Sobral I, Barão, Tianguá I,
        -- Asa Branca, trânsito
        and estoque.id not in (145, 156, 202, 159, 721)
        -- Produtos de revenda
        and produto.tipo = '00'
),

agrupado as (
    select
        empresa.nome as empresa,
        sum(dados.estoque) as estoque,
        sum(dados.vr_custo_venda) as vr_custo_venda,
        sum(dados.preco_venda) as preco_venda,
        sum(dados.vr_custo_ultima_compra) as vr_custo_ultima_compra

    from
        dados
        -- define proprietário do local
        join sped_participante as empresa
            on empresa.id = dados.proprietario_local_id

    where
        dados.numero = 1
        and dados.estoque > 0

    group by
        dados.numero,
        empresa.nome

    order by
        dados.numero
)

select
    agrupado.*,
    -- Geral
    sum(agrupado.vr_custo_venda) over geral as total_geral_vr_custo_venda,
    sum(agrupado.preco_venda) over geral as total_geral_preco_venda,
    sum(agrupado.vr_custo_ultima_compra) over geral as total_geral_vr_custo_ultima_compra

from
    agrupado

window
    geral as ()
