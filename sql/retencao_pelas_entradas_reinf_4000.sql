with dados_nfs as (
    select
        nfs.id as nfs_id,
        nfs.empresa_id as empresa_id,
        nfs.data_emissao as data_emissao,
        nfs.participante_id as participante_id,
        nfs.numero as numero,
        nfs.vr_nf as vr_nf,
        nfs.vr_irpj_retido as vr_irpj_retido,
        nfs.vr_csll_retido as vr_csll_retido,
        nfs.vr_pis_retido as vr_pis_retido,
        nfs.vr_cofins_retido as vr_cofins_retido

    from
        sped_documento as nfs

    where
        nfs.data_apuracao between '2023-10-01' and '2023-10-31'
        -- limita apenas ao modelo NF-s
        and nfs.modelo  = '03'
        and nfs.simulacao = False
        and nfs.entrada_saida = '0'
        and nfs.natureza_receita_reinf is not null
        and (nfs.vr_pis_retido > 0 or nfs.vr_cofins_retido > 0 or nfs.vr_csll_retido > 0 or nfs.vr_irpj_retido > 0)
),

dados_fatura_locacao as (
    select
        fatura_locacao.id as fatura_locacao_id,
        fatura_locacao.empresa_id as empresa_id,
        fatura_locacao.data_emissao as data_emissao,
        fatura_locacao.participante_id as participante_id,
        fatura_locacao.numero as numero,
        fatura_locacao.vr_nf as vr_nf,
        fatura_locacao.vr_irpj_retido as vr_irpj_retido,
        fatura_locacao.vr_csll_retido as vr_csll_retido,
        fatura_locacao.vr_pis_retido as vr_pis_retido,
        fatura_locacao.vr_cofins_retido as vr_cofins_retido

    from
        sped_documento as fatura_locacao
        join sped_participante as participante
            on participante.id = fatura_locacao.participante_id

    where
        fatura_locacao.data_apuracao between '2023-10-01' and '2023-10-31'
        -- limita apenas ao modelo Fatura de locação
        and fatura_locacao.modelo  = 'FL'
        and fatura_locacao.simulacao = False
        and fatura_locacao.entrada_saida = '0'
        and fatura_locacao.natureza_receita_reinf is not null
        and participante.tipo_pessoa = 'F'
),

dados_mesclados as (
    select
        documento.empresa_id as empresa_id,
        documento.modelo as modelo,
        documento.data_emissao as data_emissao,
        documento.participante_id as participante_id,
        documento.numero as numero,
        documento.vr_nf as vr_nf,
        documento.vr_irpj_retido as vr_irpj_retido,
        documento.vr_csll_retido as vr_csll_retido,
        documento.vr_pis_retido as vr_pis_retido,
        documento.vr_cofins_retido as vr_cofins_retido

    from
        sped_documento as documento
        left join dados_nfs
            on dados_nfs.nfs_id = documento.id
        left join dados_fatura_locacao
            on dados_fatura_locacao.fatura_locacao_id = documento.id

    where
        (dados_nfs.nfs_id is not null or dados_fatura_locacao.fatura_locacao_id is not null)

    group by
        documento.empresa_id,
        documento.modelo,
        documento.data_emissao,
        documento.participante_id,
        documento.numero,
        documento.vr_nf,
        documento.vr_irpj_retido,
        documento.vr_csll_retido,
        documento.vr_pis_retido,
        documento.vr_cofins_retido
),

dados as (
    select
        empresa_participante.nome as empresa,
        dados_mesclados.data_emissao as emissao,
        participante.cnpj_cpf as cnpj_cpf,
        participante.nome as prestador,
        dados_mesclados.numero as numero,
        left(modelo.nome, position(' - ' in modelo.nome) -1) as modelo,
        dados_mesclados.vr_nf as valor_nota,
        dados_mesclados.vr_irpj_retido as irpj,
        dados_mesclados.vr_csll_retido as csll,
        dados_mesclados.vr_pis_retido as pis,
        dados_mesclados.vr_cofins_retido as cofins

    from
        dados_mesclados
        join sped_participante as participante
            on participante.id = dados_mesclados.participante_id
        join sped_empresa as empresa
            on empresa.id = dados_mesclados.empresa_id
        join sped_participante as empresa_participante
            on empresa_participante.id = empresa.participante_id
        join sped_documento_modelo_fiscal as modelo
            on modelo.codigo = dados_mesclados.modelo
)

select
    dados.*,
    -- Geral
    sum(dados.valor_nota) over geral as total_geral_valor_nota,
    sum(dados.irpj) over geral as total_geral_irpj,
    sum(dados.csll) over geral as total_geral_csll,
    sum(dados.pis) over geral as total_geral_pis,
    sum(dados.cofins) over geral as total_geral_cofins,
    -- Grupo 1
    sum(dados.valor_nota) over grupo_1 as grupo_1_valor_nota,
    sum(dados.irpj) over grupo_1 as grupo_1_irpj,
    sum(dados.csll) over grupo_1 as grupo_1_csll,
    sum(dados.pis) over grupo_1 as grupo_1_pis,
    sum(dados.cofins) over grupo_1 as grupo_1_cofins

from
    dados

window
    geral as (),
    grupo_1 as (partition by dados.modelo order by dados.modelo, dados.empresa, dados.numero)
