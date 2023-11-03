with dados_venda as (
    select
        item.produto_id as produto_id,
        item.quantidade as quantidade,

    -- Pegando venda do mes retrasado
        case
            when documento.data_emissao between '2023-09-04' and '2023-11-03'
            then coalesce(item.quantidade, 0)
        end as qtd_mes_atual,

    -- Pegando venda do mes passado
        case
            when documento.data_emissao between '2023-10-04' and '2023-11-03'
            then coalesce(item.quantidade, 0)
        end as qtd_mes_passado,

    -- Pegando venda do mes atual
        case
            when documento.data_emissao between '2023-10-19' and '2023-11-03'
            then coalesce(item.quantidade, 0)
        end as qtd_mes_retrasado

    from
        sped_documento_item as item
        join sped_documento as documento
            on documento.id = item.documento_id
        join sped_operacao as operacao
            on operacao.id = documento.operacao_id

    where
        documento.data_emissao between '2023-09-02' and '2023-11-01'
        and documento.simulacao = False
        and documento.situacao_nfe = 'autorizada'
        and operacao.eh_operacao_venda = True
),

saldos_agora_assistencia as(
    select
        produto.id as produto_id,
        sum(
            case
                when estoque.nome in (
                    'Assistência Zenir',
                    'Assistência Móveis',
                    'Assistência Informatica Celulares'
                )
                then coalesce(saldo_hoje.saldo, 0)
            end
        ) as saldo_assistencia,

        sum(
            case
                when estoque.exibe_saldo_venda = True
                then coalesce(saldo_hoje.saldo, 0)
                else 0
            end
        ) as saldo_mes_agora

    from
        sped_produto as produto
        join estoque_saldo_hoje as saldo_hoje
            on saldo_hoje.produto_id = produto.id
        join estoque_local as estoque
            on estoque.id = saldo_hoje.local_id

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
        sum(coalesce(dados_venda.qtd_mes_retrasado, 0)) as qtd_mes_retrasado,
        sum(coalesce(dados_venda.qtd_mes_passado, 0)) as qtd_mes_passado,
        sum(coalesce(dados_venda.qtd_mes_atual, 0)) as qtd_mes_atual,
        (
            60 + (select extract(day from current_date))
        ) as dias_cobertura,
        coalesce(saldos_agora_assistencia.saldo_assistencia, 0) as saldo_assistencia,
        coalesce(saldos_agora_assistencia.saldo_mes_agora, 0) as saldo_mes_agora,
        coalesce(produto.fora_linha, False) as fora_linha

    from
        sped_produto as produto
        join sped_produto_familia as familia
            on familia.id = produto.familia_id
        left join saldos_agora_assistencia
            on saldos_agora_assistencia.produto_id = produto.id
        left join dados_venda
            on dados_venda.produto_id = produto.id

    where
        produto.fabricante_id = 1316392
        and familia.familia_superior_id = 4


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
        agrupado.qtd_mes_retrasado as qtd_mes_retrasado,
        agrupado.qtd_mes_passado as qtd_mes_passado,
        agrupado.qtd_mes_atual as qtd_mes_atual,
        agrupado.saldo_mes_agora as saldo_mes_agora,
        agrupado.saldo_assistencia as saldo_assistencia,
        coalesce(dados.qtd_externo, 0) as qtd_externo,
        (
            agrupado.saldo_mes_agora + agrupado.saldo_assistencia + coalesce(dados.qtd_externo, 0)
        ) as saldo_total,

        -- Cáuculo da cobertura
        cast(
            case
                when
                    agrupado.qtd_mes_retrasado + agrupado.qtd_mes_passado + agrupado.qtd_mes_atual > 0
                then round(
                    agrupado.saldo_mes_agora / ((
                        (agrupado.qtd_mes_retrasado + agrupado.qtd_mes_passado + agrupado.qtd_mes_atual) / agrupado.dias_cobertura
                    ) * 30)
                , 2)
                else 0
            end as numeric(8, 2)
        ) as cobertura,

        -- Excesso?
        case
            when 
                agrupado.qtd_mes_retrasado + agrupado.qtd_mes_passado + agrupado.qtd_mes_atual > 0
            then
                case
                    when round(
                        agrupado.saldo_mes_agora / ((
                            (agrupado.qtd_mes_retrasado + agrupado.qtd_mes_passado + agrupado.qtd_mes_atual) / agrupado.dias_cobertura
                        ) * 30)
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

    where
        agrupado.qtd_mes_retrasado > 0
        or agrupado.qtd_mes_passado > 0
        or agrupado.qtd_mes_atual > 0
        or agrupado.saldo_mes_agora > 0
)


select
    dados_calculados.*,
    -- Geral
    sum(dados_calculados.qtd_mes_retrasado) over geral AS total_geral_qtd_mes_retrasado,
    sum(dados_calculados.qtd_mes_passado) over geral AS total_geral_qtd_mes_passado,
    sum(dados_calculados.qtd_mes_atual) over geral AS total_geral_qtd_mes_atual,
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
