with dados as (
    select
        documento.nome as documento,
        documento.chave as chave,
        operacao.nome as operacao,
        documento.data_emissao as data_emissao,
        participante.nome as participante,
        documento.vr_nf as vr_nf,
        manifestacao.data_hora_confirmacao_real as data_hora_confirmacao_real

    from
        sped_documento as documento
        join sped_consulta_dfe_item as manifestacao
            on manifestacao.chave = documento.chave
        join sped_participante as participante
            on participante.id = documento.participante_id
        join sped_operacao as operacao
            on operacao.id = documento.operacao_id

    where
        documento.data_emissao between '2024-01-01' and '2024-01-30'
        -- Apenas do tipo 'Recebimento'
        and documento.emissao = '1'
        -- Apenas de modelo 'NF-e'
        and documento.modelo = '55'
        -- Filtra a empresa
        and documento.empresa_id = 353
        and documento.situacao_fiscal in ('00','01','06','07','08')
),

agrupado as (
    select
        dados.documento as documento,
        dados.chave as chave,
        dados.operacao as operacao,
        dados.data_emissao as data_emissao,
        dados.participante as participante,
        dados.vr_nf as vr_nf

    from
        dados

    where
        not exists (
            select
                1
            from
                dados as dd
            where
                dd.data_hora_confirmacao_real is not null
                and dd.chave = dados.chave
        )

    group by
        dados.documento,
        dados.chave,
        dados.operacao,
        dados.data_emissao,
        dados.participante,
        dados.vr_nf
)

select
    agrupado.*

from
    agrupado
