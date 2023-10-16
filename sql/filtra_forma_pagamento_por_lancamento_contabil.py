from tqdm import tqdm

SQL = '''
select
    documento.id

from
    contabil_lancamento as lancamento
    join sped_documento as documento
        on documento.id = lancamento.sped_documento_id

where
    lancamento.data_lancamento between '2023-05-01' and '2023-08-04'
    and lancamento.situacao = 'provisorio'
    and lancamento.valor is null
    and lancamento.referencia_id like 'sped.documento%'
    and documento.pedido_id is not null
    and documento.forma_pagamento_id is not null;
'''

self.env.cr.execute(SQL)
dados = self.env.cr.fetchall()


def insere_forma_pagamento():
    for documento_id, in tqdm(dados):
        documento = self.env['sped.documento'].browse(documento_id)

        print(f'Vamos ajustar o documento {documento.nome}')

        documento.forma_pagamento_id = documento.pedido_id.forma_pagamento_id
        documento.finan_conta_id = documento.pedido_id.finan_conta_id
        documento.condicao_pagamento_id = documento.pedido_id.condicao_pagamento_id
        documento.flush()
        self.env.cr.commit()

        print(f'Ajustou o documento {documento.nome}')

        documento.invalidate_cache()
        del documento
