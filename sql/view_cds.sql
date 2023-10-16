with dados as (
    select
        produto.codigo as codigo,
        produto.nome as produto,
        grupo.nome as grupo,
        saldo_hoje.saldo as grupo_zenir, 
        -- Se dono do local é cd iguatu, então passa
        case
            when estoque.proprietario_local_id = 698
            then saldo_hoje.saldo
        end as cd_iguatu,

        -- Se dono do local é cd sobral, então passa
        case
            when estoque.proprietario_local_id = 704
            then saldo_hoje.saldo
        end as cd_sobral,

        -- Se dono do local é cd fortaleza, então passa
        case
            when estoque.proprietario_local_id = 690
            then saldo_hoje.saldo
        end as cd_fortaleza,

        -- Se dono do local é cd juazeiro, então passa
        case
            when estoque.proprietario_local_id = 766
            then saldo_hoje.saldo
        end as cd_juazeiro

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
        (saldo_hoje.saldo > 0 or saldo_hoje.saldo is not null)
        -- É 'Disponível para venda'?
        and estoque.exibe_saldo_venda = 'True'
        -- Disponível venda: campos sales I, Sobral I, Barão, Tianguá I,
        -- Asa Branca, trânsito
        and estoque.id not in (145, 156, 202, 159, 721)
        -- Se existe familia superior
        and subgrupo.familia_superior_id is not null
        -- produtos de revenda
        and produto.tipo = '00'
        -- Se familia superior igual ao valor repassado
        and grupo.id in (2)
),

agrupado as (
    select
        dados.codigo as codigo,
        dados.produto as produto,
        dados.grupo as grupo,
        sum(coalesce(dados.grupo_zenir, 0)) as grupo_zenir,
        sum(coalesce(dados.cd_iguatu, 0)) as cd_iguatu,
        sum(coalesce(dados.cd_sobral, 0)) as cd_sobral,
        sum(coalesce(dados.cd_fortaleza, 0)) as cd_fortaleza,
        sum(coalesce(dados.cd_juazeiro, 0)) as cd_juazeiro

    from
        dados

    group by
        dados.codigo,
        dados.produto,
        dados.grupo

    order by
        dados.grupo
)

select
    agrupado.*,
    -- Se existe saldo, defina porcentagem cd iguatu
    case
        when agrupado.grupo_zenir > 0
        then round(agrupado.cd_iguatu * 100 / agrupado.grupo_zenir, 1)
        else 0.0
    end as porcent_cd_iguatu,

    -- Se existe saldo, defina porcentagem cd sobral
    case
        when agrupado.grupo_zenir > 0
        then round(agrupado.cd_sobral * 100 / agrupado.grupo_zenir, 1)
        else 0.0
    end as porcent_cd_sobral,

    -- Se existe saldo, defina porcentagem cd fortaleza
    case
        when agrupado.grupo_zenir > 0
        then round(agrupado.cd_fortaleza * 100 / agrupado.grupo_zenir, 1)
        else 0.0
    end as porcent_cd_fortaleza,

    -- Se existe saldo, defina porcentagem cd juazeiro
    case
        when agrupado.grupo_zenir > 0
        then round(agrupado.cd_juazeiro * 100 / agrupado.grupo_zenir, 1)
        else 0.0
    end as porcent_cd_juazeiro

from
    agrupado

window
    geral as (partition by agrupado.grupo)
