def executa():
    # selecionando produto
    lotes = self.env['finan.lote.cobranca'].search([])

    # Itera em produtos no caso de cadastros duplicado no odoo
    for lote in lotes:
        numero = lote.numero
        print(f'lote: {numero}')

        # Escreve dados
        lote.unlink()
        lote.flush()
        self.env.cr.commit()

        print(f'lote: {numero} - Apagado!')

        print(55 * '-')

        del numero

    # Limpando cache
    lote.invalidate_cache()


executa()
