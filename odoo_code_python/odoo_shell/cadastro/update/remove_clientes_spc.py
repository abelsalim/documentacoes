from tqdm import tqdm


def executa():
    # Coleta clientes negativados
    clientes = self.env['sped.participante'].search(
        [
            ('cliente_negativado_spc', '=', True)
        ]
    )

    # Itera nos clientes
    for cliente in tqdm(clientes):

        if not cliente.cliente_negativado_spc:
            continue

        print(
            f'{cliente.nome} - {cliente.cnpj_cpf} - '
            f'{cliente.cliente_negativado_spc}'
        )

        # Atribui e grava no banco
        cliente.cliente_negativado_spc = False
        cliente.flush()
        self.env.cr.commit()

        print(f'{cliente.nome} - {cliente.cnpj_cpf} - Alterado!')

        cliente.invalidate_cache()


executa()
