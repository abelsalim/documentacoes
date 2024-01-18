with dados as (
    select
        os.id as os_id,
        os.numero as os,
        coalesce(to_char(os.data_orcamento, 'DD/MM/YYYY'), '') as data_criacao,
        coalesce(pedido.numero, '') as pedido,
        case
            when
                cliente.nome is not null
            then
                concat(cliente.nome, ' [', cliente.cnpj_cpf,']')
            else
                ''
        end as cliente,
        case
            when
                loja_venda.nome is not null
            then
                concat(loja_venda.nome, ' [', loja_venda.cnpj_cpf,']')
            else
                ''
        end as loja_venda,
        case
            when
                loja_montagem.nome is not null
            then
                concat(loja_montagem.nome, ' [', loja_montagem.cnpj_cpf,']')
            else
                ''
        end as loja_montagem,
        coalesce(regional.nome, '') as regional,
        coalesce(montador.nome, '') as montador,
        coalesce(etapa.nome, '') as etapa
        -- coalesce(subgrupo.nome, '') as subgrupo

    from
        pedido_documento as os
        left join pedido_documento as pedido
            on pedido.id = os.pedido_original_id
        join sped_participante as cliente
            on cliente.id = os.participante_id
        -- empresa da venda
        left join sped_empresa as empresa_venda
            on empresa_venda.id = pedido.empresa_id
        left join sped_participante as loja_venda
            on loja_venda.id = empresa_venda.participante_id
        -- empresa da montagem
        join sped_empresa as empresa_montagem
            on empresa_montagem.id = os.empresa_id
        join sped_participante as loja_montagem
            on loja_montagem.id = empresa_montagem.participante_id
        -- grupo regional
        left join sped_empresa_grupos as regional
            on regional.id = empresa_montagem.grupo_regional_id
        --  tecnico
        left join sped_participante as montador
            on montador.id = os.tecnico_id
        -- etapa os
        join pedido_etapa as etapa
            on etapa.id = os.etapa_id
        -- produtos
        -- left join sped_documento_item as item
        --     on item.pedido_id = os.id
        -- left join sped_produto as produto
        --     on produto.id = item.produto_id
        -- left join sped_produto_familia as subgrupo
        --     on subgrupo.id = produto.familia_id

    where
        os.data_orcamento between '2023-08-01' and '2024-01-31'
        and os.operacao_id = 143
)

select
    dados.data_criacao as data_criacao,
    (
        select
            coalesce(max(to_char(data_conclusao.create_date, 'DD/MM/YYYY')), '')
        from
            pedido_documento_historico as data_conclusao
        where
            data_conclusao.pedido_id = dados.os_id
            and data_conclusao.etapa_id = 182
    ) as data_conclusao,
    dados.os as os,
    dados.pedido as pedido,
    dados.cliente as cliente,
    dados.loja_venda as loja_venda,
    dados.loja_montagem as loja_montagem,
    dados.regional as regional,
    dados.montador as montador,
    dados.etapa as etapa
    -- dados.subgrupo as subgrupo

from
    dados
