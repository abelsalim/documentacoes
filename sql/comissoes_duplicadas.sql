with dados as (
    select
        cr.numero as cr,
        etapa.nome as etapa,
        coalesce(to_char(cr.data_aprovacao, 'DD/MM/YYYY'), '') as data_aprovacao,
        a_receber.codigo as a_receber,
        cobrador.nome as cobrador,
        cliente.nome as cliente

    from
        finan_lancamento as recebimento
        join finan_lancamento as a_receber
            on a_receber.id = recebimento.divida_unica_id
        join sped_participante as cobrador
            on cobrador.id = recebimento.cobrador_id
        join sped_participante as cliente
            on cliente.id = a_receber.participante_id
        join finan_lancamento_cobranca_divida as relacionamento_cr
            on relacionamento_cr.divida_id = a_receber.id
        join pedido_documento as cr
            on cr.id = relacionamento_cr.cobranca_id
        join sped_empresa
            on sped_empresa.id = a_receber.empresa_id
        join sped_participante as empresa
            on empresa.id = sped_empresa.participante_id
        join pedido_etapa as etapa
            on etapa.id = cr.etapa_id

    where
        recebimento.valor_comissao_cobrador is not null
        and recebimento.tipo = 'recebimento'
        and recebimento.valor_comissao_cobrador > 0
        and cr.etapa_id in (304,305)

    order by
        a_receber.codigo
)

select
    dados.*

from
    dados

where
    dados.a_receber in (
        select
            dados.a_receber
        from
            dados
        group by
            dados.a_receber
        having
            count(dados.cr) != 1
    )

order by
    dados.a_receber
