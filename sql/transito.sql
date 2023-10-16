---
--- Este é o SQL do relatório Produtos Em Trânsito Resumido (ID 317)
--- Solicitado por Abel Salim Campos da Costa
--- Solicitado em 06/07/2023 18:03:19
---
with produtos_transito as (
select
    spro.codigo,
	spro.nome,
	sum(sdi.quantidade) as quantidade,
	sum(sdi.vr_operacao) as valor_total

from sped_documento sd 
	join sped_documento_item sdi on sdi.documento_id = sd.id
	join sped_produto spro on spro.id = sdi.produto_id
--     left join sped_consulta_dfe_item sdci ON sd.chave = sdci.chave and sdci.data_hora_confirmacao is not null 
	join estoque_extrato ext on sd.id = ext.documento_id
--     join sped_participante sp on sp.id = sd.participante_id 
-- 	join sped_operacao so on sd.operacao_id = so.id

where spro.active = true
    and sd.entrada_saida = '1' 
    and sd.modelo = '55' 
    and sd.chave is not null
    and ext.local_id = 242 
	
-- 	select count(id) from estoque_extrato where documento_id = 4351965
	
    and sd.data_emissao between '2023-05-12' and '2023-05-12'
    and sd.situacao_fiscal in ('00','01','06','07','08')
    and (select COALESCE(count(ex.id),0) as id 
		 from estoque_extrato ex 
		 where ex.documento_id = (select id from sped_documento d 
							      where d.chave = sd.chave 
							      and d.entrada_saida = '0' limit 1) 
		 and ex.data between '2023-05-12' and '2023-05-12' ) <= 0
    and sd.empresa_id = 367
    
group by 
    spro.codigo,
    spro.nome
	
order by lpad(spro.codigo, 8, '0')
)

select produtos_transito.*,
    sum(produtos_transito.quantidade) over geral as total_geral_quantidade,
    sum(produtos_transito.valor_total) over geral as total_geral_valor_total

from produtos_transito

window geral as ()

order by lpad(produtos_transito.codigo, 8, '0')

-- ****************************************************************************

select
    produto.codigo,
    produto.nome,
    -- sum(item.quantidade) as quantidade,
    -- sum(item.vr_nf) as valor_total,
    nfe_entrada.operacao_id

from sped_documento as nfe_saida
    left join sped_documento as nfe_entrada
        on nfe_entrada.chave = nfe_saida.chave
    join sped_operacao as operacao_entrada
        on operacao_entrada.id = nfe_entrada.operacao_id
    join sped_consulta_dfe_item as consulta_dfe
        on consulta_dfe.chave = nfe_entrada.chave
    join sped_documento_item as item
        on item.documento_id = nfe_saida.id
    join sped_produto as produto
        on produto.id = item.produto_id

where
    nfe_saida.data_emissao between '2023-05-01' and '2023-05-31'
    and nfe_saida.empresa_id = 367
    and operacao_entrada.id in (88, 152, 17)
    and nfe_entrada.entrada_saida = '0'
    and consulta_dfe.data_hora_confirmacao is not null

group by 
    produto.codigo,
    produto.nome,
    nfe_entrada.operacao_id;

-- ****************************************************************************

with produtos_transito as (
    select
        produto.codigo,
        produto.nome,
        sum(item.quantidade) as quantidade,
        sum(item.vr_nf) as valor_total

    from sped_documento as nfe_saida
        left join sped_documento as nfe_entrada
            on nfe_entrada.chave = nfe_saida.chave
        join sped_operacao as operacao_entrada
            on operacao_entrada.id = nfe_entrada.operacao_id
        join sped_consulta_dfe_item as consulta_dfe
            on consulta_dfe.chave = nfe_entrada.chave
        join sped_documento_item as item
            on item.documento_id = nfe_saida.id
        join sped_produto as produto
            on produto.id = item.produto_id

    where
        nfe_saida.data_emissao between '2023-05-12' and '2023-05-12'
        and nfe_saida.situacao_nfe = 'autorizada'
        and nfe_saida.empresa_id = 367
        and operacao_entrada.id in (88, 152, 17)
        and nfe_entrada.entrada_saida = '0'
        and consulta_dfe.data_hora_confirmacao is not null

    group by 
        produto.codigo,
        produto.nome
)

select produtos_transito.*,
    sum(produtos_transito.quantidade) as quantidade_produtos,
    sum(produtos_transito.valor_total) as valor_total
from produtos_transito;

-- ****************************************************************************

with id_empresas_j_alves (
    select id from sped_empresa
)


select
    --empresa.nome,
    --sum(nfe_entrada.vr_nf) as quantidade
    nfe_entrada.numero,
    nfe_entrada.vr_nf

from sped_documento as nfe_saida
    left join sped_documento as nfe_entrada
        on nfe_entrada.chave = nfe_saida.chave
    --join sped_operacao as operacao_entrada
    --    on operacao_entrada.id = nfe_entrada.operacao_id

where
    nfe_saida.emissao between '2023-05-01' and '2023-05-31'
    and nfe_saida.empresa_id = 367;
    --and operacao_entrada.id in (88, 152, 17)
    --and nfe_entrada.entrada_saida = '0'
    --and nfe_entrada.participante_id in id_empresas_j_alves





-- MÉTODO ANTIGO
select
    datepart(month, nfe_saida.data_emissao),
    nfe_entrada.numero,
    nfe_entrada.vr_nf

from sped_documento as nfe_saida
    left join sped_documento as nfe_entrada
        on nfe_entrada.chave = nfe_saida.chave
    join sped_empresa as empresa
        on empresa.id = nfe_saida.empresa_id

where
    nfe_entrada.data_entrada_saida between '2023-05-01' and '2023-05-31'
    and '00' in (nfe_saida.situacao_fiscal, nfe_entrada.situacao_fiscal)
    and nfe_saida.empresa_id = '367'
    and nfe_entrada.participante_id = empresa.participante_id
    and nfe_saida.situacao_nfe = 'autorizada'
    and nfe_entrada.entrada_saida = '0'
    and nfe_entrada.data_entrada_saida is not null

group by
    nfe_entrada.numero,
    nfe_entrada.vr_nf;
-- ----------------------------------------------------------------------------

select
    -- datepart(month, nfe_saida.data_emissao),
    nfe_entrada.numero,
    nfe_entrada.vr_nf

from sped_documento as nfe_saida
    left join sped_documento as nfe_entrada
        on nfe_entrada.chave = nfe_saida.chave
    join sped_empresa as empresa
        on empresa.id = nfe_saida.empresa_id
    join sped_operacao as operacao_entrada
        on operacao_entrada.id = nfe_entrada.operacao_id

where
    nfe_saida.data_emissao between '2023-05-01' and '2023-05-31'
    and operacao_entrada.id in (88, 152, 17)
    and '00' in (nfe_saida.situacao_fiscal, nfe_entrada.situacao_fiscal)
    and nfe_saida.empresa_id = '367'
    and nfe_entrada.participante_id = empresa.participante_id
    and nfe_saida.situacao_nfe = 'autorizada'
    and nfe_entrada.entrada_saida = '0'
    and nfe_entrada.data_entrada_saida is null

group by
    nfe_entrada.numero,
    nfe_entrada.vr_nf;


-- ----------------------------------------------------------------------------

select
    count(nfe_entrada.numero) as numero_de_notas,
    sum(nfe_entrada.vr_nf) as valor_total

from sped_documento as nfe_saida
    left join sped_documento as nfe_entrada
        on nfe_entrada.chave = nfe_saida.chave
    join sped_operacao as operacao_entrada
        on operacao_entrada.id = nfe_entrada.operacao_id

where
    nfe_saida.data_emissao between '2023-04-01' and '2023-04-30'
    and operacao_entrada.id in (88, 152, 17)
    and nfe_entrada.empresa_id = '342'
    and nfe_entrada.data_apuracao < '2023-04-30';





-- Funcionou!!!
-- Iniciaram em trânsito no mês de maio, mas emitidas em abril

with notas as (
    select
        nfe_entrada.numero,
        nfe_entrada.vr_nf

    from sped_documento as nfe_saida
        left join sped_documento as nfe_entrada
            on nfe_entrada.chave = nfe_saida.chave
        join sped_operacao as operacao_entrada
            on operacao_entrada.id = nfe_entrada.operacao_id

    where
        nfe_saida.data_emissao between '2023-04-01' and '2023-04-30'
        and operacao_entrada.id in (88, 152, 17)
        and nfe_entrada.empresa_id = '379'
        and nfe_entrada.data_apuracao > '2023-04-30'

    group by
        nfe_entrada.numero,
        nfe_entrada.vr_nf
)

select count(notas.numero), sum(notas.vr_nf) from notas;

-- ----------------------------------------------------------------------------



select
    produto.codigo,
    produto.nome,
    nfe_entrada.numero,
    nfe_entrada.vr_nf

from sped_documento as nfe_saida
    left join sped_documento as nfe_entrada
        on nfe_entrada.chave = nfe_saida.chave
    join sped_operacao as operacao_entrada
        on operacao_entrada.id = nfe_entrada.operacao_id
    join sped_documento_item as item
        on item.documento_id = nfe_entrada.id
    join sped_produto as produto
        on produto.id = item.produto_id

where
    nfe_saida.data_emissao between '2023-04-01' and '2023-04-30'
    and operacao_entrada.id in (88, 152, 17)
    and nfe_entrada.empresa_id = '379'
    and nfe_entrada.data_apuracao > '2023-04-30'

group by
    produto.codigo,
    produto.nome,
    nfe_entrada.numero,
    nfe_entrada.vr_nf;




with notas as (
    select
        produto.codigo,
        produto.nome,
        sum(item.quantidade) as quantidade,
        sum(item.vr_produtos) as valor_total


    from sped_documento as nfe_saida
        left join sped_documento as nfe_entrada
            on nfe_entrada.chave = nfe_saida.chave
        join sped_operacao as operacao_entrada
            on operacao_entrada.id = nfe_entrada.operacao_id
        join sped_documento_item as item
            on item.documento_id = nfe_entrada.id
        join sped_produto as produto
            on produto.id = item.produto_id

    where
        nfe_saida.data_emissao between '2023-04-01' and '2023-04-30'
        and operacao_entrada.id in (88, 152, 17)
        and nfe_entrada.empresa_id = '379'
        and nfe_entrada.data_apuracao > '2023-04-30'

    group by
        produto.codigo,
        produto.nome
)

select
    notas.codigo,
    notas.nome,
    notas.quantidade,
    notas.valor_total,
    notas.quantidade * notas.valor_total as valor

from notas;


-- Testes

-- print da operacao, numero da nota e valor da nota
select
        operacao_entrada.nome,
        nfe_entrada.numero,
        nfe_entrada.vr_nf

    from sped_documento as nfe_saida
        left join sped_documento as nfe_entrada
            on nfe_entrada.chave = nfe_saida.chave
        join sped_operacao as operacao_entrada
            on operacao_entrada.id = nfe_entrada.operacao_id
        join sped_documento_item as item
            on item.documento_id = nfe_entrada.id
        join sped_produto as produto
            on produto.id = item.produto_id

    where
        nfe_saida.data_emissao between '2023-04-01' and '2023-04-30'
        and operacao_entrada.id in (88, 152, 17)
        and nfe_entrada.empresa_id = '379'
        and nfe_entrada.data_apuracao > '2023-04-30'

    group by
        operacao_entrada.nome,
        nfe_entrada.numero,
        nfe_entrada.vr_nf;




with notas as (
    select
        produto.codigo,
        produto.nome,
        item.quantidade,
        item.vr_produtos


    from sped_documento as nfe_saida
        left join sped_documento as nfe_entrada
            on nfe_entrada.chave = nfe_saida.chave
        join sped_operacao as operacao_entrada
            on operacao_entrada.id = nfe_entrada.operacao_id
        join sped_documento_item as item
            on item.documento_id = nfe_entrada.id
        join sped_produto as produto
            on produto.id = item.produto_id

    where
        nfe_saida.data_emissao between '2023-04-01' and '2023-04-30'
        and operacao_entrada.id in (88, 152, 17)
        and nfe_entrada.empresa_id = '352'
        and nfe_entrada.data_apuracao > '2023-04-30'

    group by
        produto.codigo,
        produto.nome,
        item.quantidade,
        item.vr_produtos
)

select
    notas.codigo,
    notas.nome,
    notas.quantidade,
    notas.vr_produtos

from notas;







-- Para o Odoo


with produtos_transito as (
    select
        produto.codigo,
        produto.nome,
        sum(item.quantidade) as quantidade,
        sum(item.vr_produtos) as valor_total


    from sped_documento as nfe_saida
        left join sped_documento as nfe_entrada
            on nfe_entrada.chave = nfe_saida.chave
        join sped_operacao as operacao_entrada
            on operacao_entrada.id = nfe_entrada.operacao_id
        join sped_documento_item as item
            on item.documento_id = nfe_entrada.id
        join sped_produto as produto
            on produto.id = item.produto_id

    where
        nfe_saida.data_emissao between '{executa.data_inicial}' and '{executa.data_final}'
        and operacao_entrada.id in (88, 152, 17)
        and nfe_entrada.data_apuracao > '{executa.data_final}'
        {where_empresa}

    group by
        produto.codigo,
        produto.nome
)

select
    produtos_transito.codigo,
    produtos_transito.nome,
    produtos_transito.quantidade,
    produtos_transito.quantidade * produtos_transito.valor_total as valor_total,
    sum(produtos_transito.quantidade) over geral as total_geral_quantidade,
    sum(produtos_transito.valor_total) over geral as total_geral_valor_total

from produtos_transito

window geral as ()
