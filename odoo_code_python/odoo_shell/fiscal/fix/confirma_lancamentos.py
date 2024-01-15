from tqdm import tqdm

lancamentos = self.env['contabil.lancamento'].search(
    [
        ('data_lancamento', '>=', '2023-05-01'),
        ('data_lancamento', '<=', '2023-10-31'),
        ('provisorio', '=', True)
    ]
)

for lancamento in tqdm(lancamentos):
    print(lancamento.codigo)
    lancamento.confirma_lancamento()

    self.env.cr.commit()

    lancamento.invalidate_cache()
