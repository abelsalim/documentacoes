with vendas as (
    select
        documento.empresa_id as empresa_id,
        item.vr_produtos as vr_produtos,
        produto.nome as produto,
        documento.nome as numero,
        -- vendas que poderiam tem garantia estendida
        case
            when
                produto.categoria_garantia_extendida_id is not null
            then
                item.vr_produtos
            else
                0
        end as venda_elegivel

    from
        sped_documento as documento
        join sped_documento_item as item
            on item.documento_id = documento.id
        join sped_produto as produto
            on item.produto_id = produto.id
        join sped_participante as participante
            on participante.id = documento.participante_id

    where
        documento.data_emissao between '2023-11-10' and '2023-11-10'
        and documento.operacao_id in (2, 4, 5, 168)
        and documento.situacao_nfe = 'autorizada'
        and documento.pedido_id is not null
        and documento.entrada_saida = '1'
        and documento.simulacao = False
        and participante.tipo_pessoa != 'J'
        and documento.empresa_id = 376
)

select distinct
    sum(vendas.vr_produtos) as vr_produtos,
    sum(vendas.venda_elegivel) as venda_elegivel
    -- vendas.vr_produtos as vr_produtos,
    -- vendas.venda_elegivel as venda_elegivel,
    -- vendas.numero as numero,
    -- vendas.produto as produto

from
    vendas

-- order by
--     dados.numero


