with dados as (
    select
        empresa_participante.nome as empresa,
        grupo.nome as grupo,
        produto.codigo as codigo,
        produto.nome as produto,
        saldo_hoje.saldo as saldo

    from
        estoque_saldo_hoje as saldo_hoje
        left join estoque_local as estoque
            on estoque.id = saldo_hoje.local_id
        join sped_participante as empresa_participante
            on empresa_participante.id = estoque.proprietario_local_id
        join sped_empresa as empresa
            on empresa.participante_id = empresa_participante.id
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
        -- Se houver grupo
        -- and grupo.id = 2
        -- Se houver uma filial específica
        and empresa.id = 376
),

agrupado as (
    select
        dados.empresa as empresa,
        dados.grupo as grupo,
        dados.codigo as codigo,
        dados.produto as produto,
        sum(dados.saldo) as saldo

    from
        dados

    group by
        dados.empresa,
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
    -- Grugo 1
    sum(agrupado.saldo) over grupo_1 as grupo_1_saldo


from
    agrupado

window
    geral as (),
    grupo_1 as (partition by agrupado.empresa)
