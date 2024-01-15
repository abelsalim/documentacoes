from tqdm import tqdm


def executa():
    # Camptura participantes
    participantes = self.env['sped.participante'].search(
        [
            ('active', '=', True),
            ('tipo_pessoa', '=', 'F')
        ]
    )

    # Caracteres para remoção
    caracteres_removidos = '*¨\.-;,:<>/|@#$%&()!?[]{}'
    # Caracteres substitutos respectivamente
    caracteres_substituidos = '                         '

    for participante in tqdm(participantes):
        # Remove os caracteres listados e substitui respectivamente por espaços
        nome = participante.nome.translate(
            str.maketrans(caracteres_removidos, caracteres_substituidos)
        ).strip()

        razao_social = participante.razao_social.translate(
            str.maketrans(caracteres_removidos, caracteres_substituidos)
        ).strip()

        if nome != participante.nome:
            nome_antigo = participante.nome

            # Atribui valor para o participante
            participante.nome = nome

            print(f'NOME - {participante.nome} - {nome_antigo} - Alterado')

            # Salva no banco
            self.env.cr.commit()

            print(65 * '*')

        if razao_social != participante.razao_social:
            nome_antigo = participante.razao_social

            # Atribui valor para o participante
            participante.razao_social = razao_social

            print(
                f' RAZÃO SOCIAL - {participante.razao_social} - {nome_antigo} '
                '- Alterado'
            )

            # Salva no banco
            self.env.cr.commit()

            print(65 * '*')

        # Limpando cache
        participante.invalidate_cache()


executa()
