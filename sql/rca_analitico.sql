with dados as (
    select
        empresa.nome as empresa,
        concat(lancamento_participante.nome, ' - ', coalesce(lancamento_participante.celular, 'Sem telefone cadastrado')) as participante,
        lancamento.data_documento as  data_documento,
        lancamento.data_vencimento_util as data_vencimento_util,
        lancamento.codigo as codigo,
        lancamento.numero as numero,
        pedido.numero as codigo_pedido,
        parcela.numero as parcela,
        documento.nome as documento,
        conta.nome_completo as conta,
        coalesce(lancamento.vr_documento, 0) as vr_documento,
        coalesce(lancamento.vr_pago_documento, 0) as vr_pago_documento,
        coalesce(lancamento.vr_saldo, 0) as vr_saldo

    from
        finan_lancamento as lancamento
        join sped_participante  as lancamento_participante
            on lancamento_participante.id = lancamento.participante_id
        join sped_empresa as lancamento_empresa
            on lancamento_empresa.id = lancamento.empresa_id
        join sped_participante as empresa
            on empresa.id = lancamento_empresa.participante_id
        join finan_conta as conta
            on conta.id = lancamento.conta_id
        join finan_documento as documento
            on documento.id = lancamento.documento_id
        left join pedido_documento as pedido
            on pedido.id = lancamento.pedido_id
        left join pedido_parcela as parcela
            on parcela.id = lancamento.pedido_parcela_id

    where 
        lancamento.tipo = 'a_receber'
        and lancamento_participante.cliente_negativado_spc = true
        and not lancamento.situacao_divida in ('provisorio', 'a_vencer', 'vence_hoje', 'quitado', 'baixado')
        and lancamento.data_documento between ('2023-01-01') and ('2023-10-12')
        and lancamento.empresa_id = 403

    order by
        empresa.nome,
        lancamento_participante.nome,
        lancamento.numero,
        lancamento.data_vencimento_util
)

select
    dados.*,
    -- Geral
    sum(dados.vr_documento) over geral as total_geral_vr_documento,
    sum(dados.vr_pago_documento) over () as total_geral_vr_pago_documento,
    sum(dados.vr_saldo) over () as total_geral_vr_saldo,
    -- Grupo 1
    sum(dados.vr_documento) over grupo_1 as grupo_1_vr_documento,
    sum(dados.vr_pago_documento) over grupo_1 as grupo_1_vr_pago_documento,
    sum(dados.vr_saldo) over grupo_1 as grupo_1_vr_saldo,
    -- Grupo 2
    sum(dados.vr_documento) over grupo_2 as grupo_2_vr_documento,
    sum(dados.vr_pago_documento) over grupo_2 as grupo_2_vr_pago_documento,
    sum(dados.vr_saldo) over grupo_2 as grupo_2_vr_saldo

from
    dados

window
    geral as (),
    grupo_1 as (partition by dados.empresa),
    grupo_2 as (partition by dados.empresa, dados.participante)
