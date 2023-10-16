with dados as (
    select
        pedido.numero as numero,
        case
            when pedido.empresa_id in (368,369,371,352,373,354,353,374,395,396,397,400,405,404,408,409,413)
                and servico.codigo = 'SM001'
                then empresa_nome.nome
            when pedido.empresa_id not in (368,369,371,352,373,354,353,374,395,396,397,400,405,404,408,409,413)
                then empresa_nome.nome
        end as empresa,
        pedido.data_orcamento as orcamento,
        pedido.data_aprovacao as aprovacao

    from
        pedido_documento as pedido
        left join pedido_documento as os
            on os.pedido_original_id = pedido.id
        left join sped_documento_item as item
            on item.pedido_id = pedido.id
        left join sped_produto as produto
            on produto.id = item.produto_id
        left join sped_produto as servico
            on servico.id = produto.id
        join sped_empresa as empresa
            on empresa.id = pedido.empresa_id
        join sped_participante as empresa_nome
            on empresa_nome.id = empresa.participante_id

    where
        pedido.data_aprovacao between '2023-05-01' and '2023-08-16'
        and pedido.tipo in ('venda', 'ecommerce')
        and pedido.etapa_id = 311
        and pedido.operacao_derivada_iniciada = True
        and os.id is null
        and produto.necessita_montagem = True
),

agrupado as (
    select distinct
        dados.numero,
        dados.empresa,
        dados.orcamento,
        dados.aprovacao

    from dados

    where
        dados.empresa is not null
)

select agrupado.* from agrupado;


-- cron

with dados as (
    select
        pedido.id as id,
        case
            when pedido.empresa_id in (368,369,371,352,373,354,353,374,395,396,397,400,405,404,408,409,413)
                and servico.codigo = 'SM001'
                then empresa_nome.nome
            when pedido.empresa_id not in (368,369,371,352,373,354,353,374,395,396,397,400,405,404,408,409,413)
                then empresa_nome.nome
        end as empresa

    from
        pedido_documento as pedido
        left join pedido_documento as os
            on os.pedido_original_id = pedido.id
        left join sped_documento_item as item
            on item.pedido_id = pedido.id
        left join sped_produto as produto
            on produto.id = item.produto_id
        left join sped_produto as servico
            on servico.id = produto.id
        join sped_empresa as empresa
            on empresa.id = pedido.empresa_id
        join sped_participante as empresa_nome
            on empresa_nome.id = empresa.participante_id

    where
        pedido.data_aprovacao between '2023-05-01' and '2023-08-16'
        and pedido.tipo in ('venda', 'ecommerce')
        and pedido.etapa_id = 311
        and pedido.operacao_derivada_iniciada = True
        and os.id is null
        and produto.necessita_montagem = True
),

agrupado as (
    select distinct
        dados.id

    from dados

    where
        dados.empresa is not null
)

select agrupado.* from agrupado;

