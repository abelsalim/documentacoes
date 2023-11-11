from tqdm import tqdm


notas = self.env['sped.documento'].search(
    [
        ('operacao_id', 'in', (283, 8, 301)),
        ('data_emissao', '>=', '2023-10-01')
    ]
)

for nota in tqdm(notas):

    for item in nota.item_ids:

        item._determina_codigo_apuracao_icms_proprio()
        item.flush()
        self.env.cr.commit()
