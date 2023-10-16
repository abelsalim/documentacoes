-- Captura nome de conta gerencial pelo código
select nome from finan_conta where codigo = '2.1.1';


-- Captura grupo econômico

select
    grupo_economico.cnpj_cpf,
    grupo_economico.nome,
    participante.cnpj_cpf,
    participante.nome

from sped_participante as participante
    join sped_participante as grupo_economico
        on grupo_economico.id = participante.grupo_economico_id

where participante.grupo_economico_id = '106941';


-- Em produção no Odoo

with dados as (

    select
        lancamento.vr_documento as valor,
        conta.nome as conta,

        -- Trata participante|grupo econômico
        case
            when fornecedor.grupo_economico_id is not null then grupo_economico.nome
            else fornecedor.nome
            end as empresa,

        -- Extrai Valores a pagar no período repassado
        case
            when lancamento.data_vencimento_util between '{executa.data_extrato_inicial}' and '{executa.data_extrato_final}'
                and lancamento.situacao_divida in ('a_vencer', 'quitado', 'quitado_parcialmente', 'vence_hoje')
                then coalesce(lancamento.vr_documento, 0)
            else 0
            end as divida_mes,

        -- Extrai Valores pagos no período repassado
        case
            when lancamento.vr_pago_documento is not null
            and lancamento.data_vencimento_util between '{executa.data_extrato_inicial}' and '{executa.data_extrato_final}'
                and lancamento.situacao_divida in ('quitado', 'quitado_parcialmente')
                then coalesce(lancamento.vr_pago_documento, 0)
            else 0
            end as valor_pago_mes,

        -- Extrai Juros de pagamento no período repassado
        case
            when lancamento.vr_pago_documento is not null
            and lancamento.data_vencimento_util between '{executa.data_extrato_inicial}' and '{executa.data_extrato_final}'
                and lancamento.situacao_divida in ('quitado', 'quitado_parcialmente')
                then coalesce(lancamento.vr_pago_juros, 0)
            else 0
            end as valor_juros_mes,

        -- Extrai Descontos de pagamento no período repassado
        case
            when lancamento.vr_pago_documento is not null
            and lancamento.data_vencimento_util between '{executa.data_extrato_inicial}' and '{executa.data_extrato_final}'
                and lancamento.situacao_divida in ('quitado', 'quitado_parcialmente')
                then coalesce(lancamento.vr_pago_desconto, 0)
            else 0
            end as valor_desconto_mes,

        -- Extrai Saldo de pagamentos do período repassado
        case
            when lancamento.data_vencimento_util between '{executa.data_extrato_inicial}' and '{executa.data_extrato_final}'
                and lancamento.situacao_divida in ('a_vencer', 'quitado', 'quitado_parcialmente', 'vence_hoje')
                then coalesce(lancamento.vr_saldo, 0)
            else 0
            end as valor_saldo_mes

    from finan_lancamento as lancamento
        join finan_conta as conta
            on conta.id = lancamento.conta_id
        join sped_participante as fornecedor
            on fornecedor.id = lancamento.participante_id
        left join sped_participante as grupo_economico
            on grupo_economico.id = fornecedor.grupo_economico_id

    where lancamento.tipo = 'a_pagar'
        -- conta gerencial: Compra de Mercadoria para Revenda
        and conta.id in {where_conta}

),

agrupado as (

    select
        dados.empresa,
        dados.conta,
        sum(dados.valor) as valor,
        sum(dados.divida_mes) as divida_mes,
        sum(dados.valor_pago_mes) as valor_pago_mes,
        sum(dados.valor_juros_mes) as valor_juros_mes,
        sum(dados.valor_desconto_mes) as valor_desconto_mes,
        sum(dados.valor_saldo_mes) as valor_saldo_mes

        from dados

        group by
            dados.empresa,
            dados.conta

        order by
            dados.empresa
)

select
    agrupado.*,

    sum(agrupado.valor) over geral as total_geral_valor,
    sum(agrupado.valor) over grupo_1 as grupo_1_valor,

    sum(agrupado.divida_mes) over geral as total_geral_divida_mes,
    sum(agrupado.divida_mes) over grupo_1 as grupo_1_divida_mes,

    sum(agrupado.valor_pago_mes) over geral as total_geral_valor_pago_mes,
    sum(agrupado.valor_pago_mes) over grupo_1 as grupo_1_valor_pago_mes,

    sum(agrupado.valor_juros_mes) over geral as total_geral_valor_juros_mes,
    sum(agrupado.valor_juros_mes) over grupo_1 as grupo_1_valor_juros_mes,

    sum(agrupado.valor_desconto_mes) over geral as total_geral_valor_desconto_mes,
    sum(agrupado.valor_desconto_mes) over grupo_1 as grupo_1_valor_desconto_mes,

    sum(agrupado.valor_saldo_mes) over geral as total_geral_valor_saldo_mes,
    sum(agrupado.valor_saldo_mes) over grupo_1 as grupo_1_valor_saldo_mes

from
    agrupado

window
    geral as (),
    grupo_1 as (partition by agrupado.conta)
