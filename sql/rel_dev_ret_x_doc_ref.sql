with dados as (
    select
        nota.data_emissao as data_emissao,
        nota.data_apuracao as data_apuracao,
        nota.numero as nota,
        participante.cnpj_cpf as cnpj,
        participante.razao_social as cliente,
        coalesce(nota.vr_nf, 0) as valor,
        coalesce(nota.bc_icms_proprio, 0) as bc,
        coalesce(nota.vr_icms_proprio, 0) as icms,
        coalesce(nota.vr_pis_proprio + nota.vr_cofins_proprio, 0) as pis_cofins,
        nota_referenciada.numero as nf_dev,
        nota_referenciada.serie as nf_dev_serie,
        participante_nota_referenciada.cnpj_cpf as nf_dev_cnpj,
        participante_nota_referenciada.razao_social as nf_dev_participante,
        nota_referenciada.data_emissao as data_dev,
        coalesce(nota_referenciada.vr_nf, 0) as valor_dev,
        coalesce(nota_referenciada.bc_icms_proprio, 0) as bc_dev,
        coalesce(nota_referenciada.vr_icms_proprio, 0) as icms_dev,
        -- colunas relacionadas ao agrupamento
        empresa.nome as empresa,
        operacao_nota.nome as operacao

    from sped_documento as nota
        -- Tabela auxiliar para nora referenciada
        join sped_documento_referenciado as tabela_auxiliar_nota
            on tabela_auxiliar_nota.documento_id = nota.id
        -- Nota referenciada
        join sped_documento as nota_referenciada
            on nota_referenciada.id = tabela_auxiliar_nota.documento_referenciado_id

        -- Empresa da venda
        join sped_empresa
            on sped_empresa.id = nota.empresa_id
        -- Participante da venda
        join sped_participante as participante
            on participante.id = nota.participante_id
        -- Participante da venda
        join sped_participante as participante_nota_referenciada
            on participante_nota_referenciada.id = nota_referenciada.participante_id

        -- Empresa
        join sped_participante as empresa
            on empresa.id = sped_empresa.participante_id

        -- Operação nota
        join sped_operacao as operacao_nota
            on operacao_nota.id = nota.operacao_id
        -- Operação nota referenciada
        join sped_operacao as operacao_nota_referenciado
            on operacao_nota_referenciado.id = nota_referenciada.operacao_id

    where nota.empresa_id = 403
        and nota.data_apuracao between '{executa.data_apuracao_inicial}' and '{executa.data_apuracao_final}'
        and nota.situacao_nfe = 'autorizada'
        and nota.simulacao is not True
        and nota.modelo = '55'
        {where_operacao}
),

agrupado as (
    select
        dados.data_emissao as data_emissao,
        dados.data_apuracao as data_apuracao,
        dados.nota as nota,
        dados.cnpj as cnpj,
        dados.cliente as cliente,
        sum(dados.valor) as valor,
        sum(dados.bc) as bc,
        sum(dados.icms) as icms,
        sum(dados.pis_cofins) as pis_cofins,
        dados.nf_dev as nf_dev,
        dados.nf_dev_serie as nf_dev_serie,
        dados.nf_dev_cnpj as nf_dev_cnpj,
        dados.nf_dev_participante as nf_dev_participante,
        dados.data_dev as data_dev,
        sum(dados.valor_dev) as valor_dev,
        sum(dados.bc_dev) as bc_dev,
        sum(dados.icms_dev) as icms_dev,
        -- colunas relacionadas ao agrupamento
        dados.empresa as empresa,
        dados.operacao as operacao

    from
        dados

    group by
        dados.empresa,
        dados.operacao,
        dados.data_emissao,
        dados.data_apuracao,
        dados.nota,
        dados.nf_dev_serie,
        dados.cnpj,
        dados.cliente,
        dados.nf_dev,
        dados.nf_dev_cnpj,
        dados.nf_dev_participante,
        dados.data_dev

    order by
        dados.empresa,
        dados.operacao,
        dados.data_emissao
)

select
    agrupado.*,
    sum(agrupado.valor) over() as total_geral_valor,
    sum(agrupado.bc) over() as total_geral_bc,
    sum(agrupado.icms) over() as total_geral_icms,
    sum(agrupado.pis_cofins) over() as total_geral_pis_cofins,
    sum(agrupado.valor_dev) over() as total_geral_valor_dev,
    sum(agrupado.bc_dev) over() as total_geral_bc_dev,
    sum(agrupado.icms_dev) over() as total_geral_icms_dev,

    sum(agrupado.valor) over(partition by agrupado.empresa) as grupo_1_valor,
    sum(agrupado.bc) over(partition by agrupado.empresa) as grupo_1_bc,
    sum(agrupado.icms) over(partition by agrupado.empresa) as grupo_1_icms,
    sum(agrupado.pis_cofins) over(partition by agrupado.empresa) as grupo_1_pis_cofins,
    sum(agrupado.valor_dev) over(partition by agrupado.empresa) as grupo_1_valor_dev,
    sum(agrupado.bc_dev) over(partition by agrupado.empresa) as grupo_1_bc_dev,
    sum(agrupado.icms_dev) over(partition by agrupado.empresa) as grupo_1_icms_dev,

    sum(agrupado.valor) over(partition by agrupado.operacao) as grupo_2_valor,
    sum(agrupado.bc) over(partition by agrupado.operacao) as grupo_2_bc,
    sum(agrupado.icms) over(partition by agrupado.operacao) as grupo_2_icms,
    sum(agrupado.pis_cofins) over(partition by agrupado.operacao) as grupo_2_pis_cofins,
    sum(agrupado.valor_dev) over(partition by agrupado.operacao) as grupo_2_valor_dev,
    sum(agrupado.bc_dev) over(partition by agrupado.operacao) as grupo_2_bc_dev,
    sum(agrupado.icms_dev) over(partition by agrupado.operacao) as grupo_2_icms_dev

from
    agrupado