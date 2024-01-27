with dados as (
    select
        empresa.nome as empresa,
        os.data_orcamento as data_os,
        os.numero  as os_numero,
        left(participante.nome, 40) as cliente,
        produto.codigo as codigo,
        left(produto.nome, 30) as produto,
        os.pedido_original_bairro as bairro,
        concat(municipio.nome, ' - ', municipio.estado) as municipio,
        (current_date - os.data_orcamento)::integer as atraso

    from
        pedido_documento as os
        -- produto
        join sped_documento_item as item
            on item.pedido_id = os.id
        join sped_produto as produto
            on produto.id = item.produto_id
        -- empresa
        join sped_empresa
            on sped_empresa.id = os.empresa_id
        join sped_participante as empresa
            on empresa.id = sped_empresa.participante_id
        -- operacao
        join pedido_operacao as operacao
            on operacao.id = os.operacao_id
        -- cliente
        join sped_participante as participante
            on participante.id = os.participante_id
        -- histórico
        join pedido_documento_historico as historico
            on historico.pedido_id = os.id
        -- municipio
        join sped_municipio as municipio
            on municipio.id = os.pedido_original_municipio_id

    where
        os.data_orcamento between '2024-01-25' and '2024-01-27'
        and historico.etapa_id = os.etapa_id
        and os.empresa_id = 375
        and os.tipo = 'os'
)

select
    dados.*

from
    dados

window
    geral as ()

order by
    dados.atraso desc
