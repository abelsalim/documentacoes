select distinct
    documento.id

from
    contabil_lancamento as lancamento
    join sped_documento as documento
        on documento.id = lancamento.sped_documento_id
    join finan_conta as conta_gerencial
        on conta_gerencial.id = documento.finan_conta_id

where
    lancamento.data_lancamento between '2023-05-01' and '2023-08-04'
    and lancamento.situacao = 'provisorio'
    and lancamento.valor is null
    and lancamento.referencia_id like 'sped.documento%'
    and documento.pedido_id is not null;


sql = f'''
select
    sd.id
from
    sped_documento sd
    join contabil_lancamento as lancamento
        on lancamento.id = sd.lancamento_contabil_id
where
    sd.operacao_id in {tuple(operacoes_contabeis.mapped('operacao_fiscal_ids').ids)}
    and sd.data_apuracao >= '{data_base}'
    {where_data_final}
    and (lancamento.valor is null or lancamento.valor = 0)
order by
    sd.data_apuracao,
    sd.id;
'''
