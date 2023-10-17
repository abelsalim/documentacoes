with dados as (
        select
        lancamento.id as id,
        lancamento.codigo as codigo,
        participante.id as participante_id,
        participante.nome as nome

    from
        finan_lancamento as lancamento
        join sped_participante as participante
            on lancamento.participante_id = participante.id

    where
        lancamento.data_vencimento between '2023-10-01' and '2023-10-17'
        -- apenas lancamentos vencidos
        and lancamento.situacao_divida = 'vencido'
        -- apenas lancamento a receber
        and lancamento.tipo = 'a_receber'
        -- apenas a(s) empresa(s) lista(s)
        and lancamento.empresa_id = 376
        -- apenas o município listado
        and participante.municipio_id = 966
        -- não inclui se já existir documento de cobrança 'CR'
        and not exists(
            select
                pedido.id

            from
                pedido_documento as pedido
                -- tabela relacional da 'CR' com a 'DR'
                join finan_lancamento_cobranca_divida as relacionamento
                    on relacionamento.cobranca_id = pedido.id
                -- lancamento lincado na 'CR'
                join finan_lancamento as cobranca
                    on cobranca.id = relacionamento.divida_id

            where
                cobranca.id = lancamento.id
                and pedido.tipo = 'cobranca_a_receber'
                -- etapas 'Em Cobrança Externo' e 'Cobrança Efetuada
                and pedido.etapa_id in (304,305)
        )

        order by
            participante.nome,
            lancamento.data_vencimento
),

captura_total as (
    select
        lancamento.id,
        lancamento.participante_id,
        participante.nome,
        participante.cnpj_cpf

    from dados
        join finan_lancamento as lancamento
            on lancamento.participante_id = dados.participante_id
        join sped_participante as participante
            on participante.id = lancamento.participante_id

    where
        -- apenas lancamentos vencidos
        lancamento.situacao_divida = 'vencido'
        -- apenas lancamento a receber
        and lancamento.tipo = 'a_receber'

    order by
        participante.nome
)

select captura_total.id from captura_total
