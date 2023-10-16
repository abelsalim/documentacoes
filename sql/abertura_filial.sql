with dados as (
    select
        produto.codigo as codigo,
        produto.nome as descricao,
        marca.nome as marca,
        cor.nome as cor,
        saldo_hoje.saldo as saldo,
        produto.preco_venda as vr_a_vista,
        produto.vr_custo_ultima_compra as vr_custo,
        grupo.nome as grupo

    from
        estoque_saldo_hoje as saldo_hoje
        left join estoque_local as estoque
            on estoque.id = saldo_hoje.local_id
        left join sped_produto as produto
            on produto.id = saldo_hoje.produto_id
        join sped_produto_marca as marca
            on marca.id = produto.marca_id
        join sped_produto_familia as subgrupo
            on subgrupo.id = produto.familia_id
        join sped_produto_familia as grupo
            on grupo.id = subgrupo.familia_superior_id
        join sped_participante
            on sped_participante.id = estoque.proprietario_local_id
        join sped_empresa as empresa
            on empresa.participante_id = sped_participante.id
        join sped_produto_sped_produto_caracteristica as caracteristica
            on caracteristica.produto_id = produto.id
        join sped_produto_caracteristica as cor
            on cor.id = caracteristica.caracteristica_id

    where
        (saldo_hoje.saldo > 0 or saldo_hoje.saldo is not null)
        -- Deve existir saldo
        and saldo_hoje.saldo is not null
        -- É 'Disponível para venda'?
        and estoque.exibe_saldo_venda = 'True'
        -- Disponível venda: campos sales I, Sobral I, Barão, Tianguá I,
        -- Asa Branca, trânsito
        and estoque.id not in (145, 156, 202, 159, 721)
        -- produtos de revenda
        and produto.tipo = '00'
        -- Se existe familia superior
        and subgrupo.familia_superior_id is not null
        -- Se familia superior igual ao valor repassado
        and grupo.id in (2)
        -- Empresa selecionada
        and empresa.id = 366
        -- delimitando característica
        and cor.caracteristica_superior_id = 1
),

agrupado as (
    select
        dados.codigo as codigo,
        dados.descricao as descricao,
        dados.marca as marca,
        dados.cor as cor,
        dados.saldo as saldo,
        dados.vr_a_vista as vr_a_vista,
        dados.vr_custo as vr_custo,
        sum(dados.saldo * dados.vr_custo) as total,
        dados.grupo as grupo

    from dados

    group by
        dados.codigo,
        dados.descricao,
        dados.marca,
        dados.cor,
        dados.saldo,
        dados.vr_a_vista,
        dados.vr_custo,
        dados.grupo

    order by
        dados.grupo
)

select
    agrupado.*

from agrupado

window
    geral as (partition by agrupado.grupo)


colunas = [
    Coluna(titulo='Código', campo='codigo', largura=16),
    Coluna(titulo='Produto', campo='produto', largura=100),
    Coluna(titulo='Marca', campo='marca', largura=40),
    Coluna(titulo='Cor', campo='cor', largura=40),
    Coluna(titulo='Saldo', campo='saldo', tipo='I'),
    Coluna(titulo='Vendido', campo='vr_a_vista', tipo='M'),
    Coluna(titulo='Vendido', campo='vr_custo', tipo='M')
]