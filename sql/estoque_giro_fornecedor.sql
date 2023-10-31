with dados_venda as (
    select
        produto.id as produto_id,
        item.quantidade as quantidade,

    -- Pegando venda do mes retrasado
        case
            when
                item.documento_id = documento.id
                and documento.data_emissao between '2023-08-31' and '2023-10-30'
            then coalesce(item.quantidade, 0)
            else 0
        end as qtd_mes_retrasado,

    -- Pegando venda do mes passado
        case
            when
                item.documento_id = documento.id
                and documento.data_emissao between '2023-09-30' and '2023-10-30'
            then coalesce(item.quantidade, 0)
            else 0
        end as qtd_mes_passado,

    -- Pegando venda do mes atual
        case
            when
                item.documento_id = documento.id
                and documento.data_emissao between '2023-10-15' and '2023-10-30'
            then coalesce(item.quantidade, 0)
            else 0
        end as qtd_mes_atual

    from
        sped_documento_item as item
        join sped_documento as documento
            on item.documento_id = documento.id
        join sped_operacao as operacao
            on operacao.id = documento.operacao_id
        join sped_produto as produto
            on produto.id = item.produto_id
        join sped_produto_familia as familia
            on familia.id = produto.familia_id

    where
        documento.data_emissao between '2023-08-31' and '2023-10-30'
        and documento.simulacao = False
        and documento.situacao_nfe = 'autorizada'
        and operacao.eh_operacao_venda = True
        and produto.fabricante_id = 93336
),

saldos_agora_assistencia as(
    select
        produto.id as produto_id,
        coalesce(
            sum(saldo_hoje.saldo) filter (where local.nome in (
                'Assistência Zenir',
                'Assistência Móveis',
                'Assistência Informatica Celulares'
            )), 0
        ) as saldo_assistencia,
        coalesce(
            sum(saldo_hoje.saldo) filter (where local.exibe_saldo_venda = True), 0
        ) as saldo_mes_agora

    from
        sped_produto as produto
        left join estoque_saldo_hoje as saldo_hoje
            on saldo_hoje.produto_id = produto.id
        left join estoque_local as local
            on local.id = saldo_hoje.local_id
        join sped_produto_familia as familia
            on familia.id = produto.familia_id

    where
        produto.fabricante_id = 93336

    group by
        produto.id
),

dados as (
    select
        dados_venda.produto_id as produto_id,

        -- Pegando produtos em OS na etapa assitencia externa
    sum(
        case
            when
                pedido.operacao_id in (222, 147, 146)
                and pedido.etapa_id in (207, 206, 163, 193)
            then coalesce(dados_venda.quantidade, 0)
            else 0
        end
    ) as qtd_externo

    from
        dados_venda
        left join pedido_documento as pedido
            on pedido.produto_id = dados_venda.produto_id

    group by
        dados_venda.produto_id
),

agrupado as (
    select
        dados_venda.produto_id as produto_id,
        produto.codigo as codigo,
        produto.nome as nome,
        sum(dados_venda.qtd_mes_atual) as qtd_mes_atual,
        sum(dados_venda.qtd_mes_passado) as qtd_mes_passado,
        sum(dados_venda.qtd_mes_retrasado) as qtd_mes_retrasado,
        sum(
            dados_venda.qtd_mes_atual + dados_venda.qtd_mes_passado + dados_venda.qtd_mes_retrasado
        ) as total_vendido,
        (
            60 + (select extract(day from current_date))
        ) as dias_cobertura,
        saldos_agora_assistencia.saldo_assistencia as saldo_assistencia,
        saldos_agora_assistencia.saldo_mes_agora as saldo_mes_agora,
        coalesce(produto.fora_linha, False) as fora_linha

    from
        sped_produto as produto
        left join saldos_agora_assistencia
            on saldos_agora_assistencia.produto_id = produto.id
        left join dados_venda
            on dados_venda.produto_id = produto.id

    where
        (dados_venda.produto_id is not null or saldos_agora_assistencia.produto_id is not null)

    group by
        dados_venda.produto_id,
        produto.codigo,
        produto.nome,
        saldos_agora_assistencia.saldo_assistencia,
        saldos_agora_assistencia.saldo_mes_agora,
        produto.fora_linha
),

dados_calculados as (
    select
        agrupado.codigo as codigo,
        agrupado.nome as nome,
        agrupado.fora_linha as fora_linha,
        agrupado.qtd_mes_atual as qtd_mes_atual,
        agrupado.qtd_mes_passado as qtd_mes_passado,
        agrupado.qtd_mes_retrasado as qtd_mes_retrasado,
        agrupado.saldo_mes_agora as saldo_mes_agora,
        agrupado.saldo_assistencia as saldo_assistencia,
        dados.qtd_externo as qtd_externo,
        agrupado.total_vendido as total_vendido,
        (
            agrupado.saldo_mes_agora + agrupado.saldo_assistencia + dados.qtd_externo
        ) as saldo_total,

        -- Cáuculo da cobertura
        cast(
            case
                when agrupado.total_vendido > 0
                then round(
                    agrupado.saldo_mes_agora / ((agrupado.total_vendido / agrupado.dias_cobertura) * 30)
                , 2)
                else 0
            end as numeric(8, 2)
        ) as cobertura,

        -- Excesso?
        case
            when agrupado.total_vendido > 0
            then
                case
                    when round(
                        agrupado.saldo_mes_agora / ((agrupado.total_vendido / agrupado.dias_cobertura) * 30)
                    , 2) >= 3
                    then 'Sim'
                else 'Não'
                end
            else 'Não'
        end as excesso

    from
        agrupado
        join dados
            on dados.produto_id = agrupado.produto_id

    where (agrupado.total_vendido > 0 or agrupado.saldo_mes_agora > 0)
)


select
    dados_calculados.*,
    -- Geral
    sum(dados_calculados.qtd_mes_atual) over geral AS total_geral_qtd_mes_atual,
    sum(dados_calculados.qtd_mes_passado) over geral AS total_geral_qtd_mes_passado,
    sum(dados_calculados.qtd_mes_retrasado) over geral AS total_geral_qtd_mes_retrasado,
    sum(dados_calculados.saldo_mes_agora) over geral AS total_geral_saldo_mes_agora,
    sum(dados_calculados.saldo_assistencia) over geral AS total_geral_saldo_assistencia,
    sum(dados_calculados.qtd_externo) over geral AS total_geral_qtd_externo,
    sum(dados_calculados.saldo_total) over geral AS total_geral_saldo_total

from
    dados_calculados

window
    geral as ()

order by
    dados_calculados.codigo
