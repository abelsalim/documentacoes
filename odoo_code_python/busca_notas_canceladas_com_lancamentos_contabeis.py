from tqdm import tqdm


def executa():
    notas = self.env['sped.documento'].search(
        [
            ('lancamento_contabil_id', '!=', None),
            ('data_emissao', '>=', '2023-10-01'),
            ('situacao_nfe', '=', 'cancelada')
        ]
    )

    for nota in tqdm(notas):
        if (lancamento_id := nota.lancamento_contabil_id.id):
            lancamento = self.env['contabil.lancamento'].browse(lancamento_id)
            lancamento.unlink()

            self.env.cr.commit()

executa()
