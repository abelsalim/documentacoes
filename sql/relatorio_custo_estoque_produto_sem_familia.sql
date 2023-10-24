with dados as (
    select
        row_number() over (
            partition by saldo.local_id, produto.id
            order by saldo.data desc
        ) as numero,
        estoque.proprietario_local_id as proprietario_local_id,
        produto.familia_id as familia_id,
        produto.codigo as codigo,
        produto.nome as produto,
        saldo.saldo as estoque,
        coalesce(produto.vr_custo_venda, 0) as vr_custo_venda,
        coalesce(produto.preco_venda, 0) as preco_venda,
        coalesce(produto.vr_custo_ultima_compra, 0) as vr_custo_ultima_compra

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
)

select
    dados.codigo as codigo,
    dados.produto as produto
    -- sum(dados.estoque) as estoque

from
    dados
    -- define proprietário do local
    join sped_participante as empresa
        on empresa.id = dados.proprietario_local_id

where
    dados.numero = 1
    and dados.estoque > 0
    and dados.familia_id is null

group by
    dados.codigo,
    dados.produto

