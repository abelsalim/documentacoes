import csv


def executa(arquivo):
    with open(arquivo, 'r') as arquivo_csv:
        arquivo_csv = csv.reader(arquivo_csv, delimiter='|')
        try:
            for linha in arquivo_csv:
                cpf, cobra, profissao, rg, apelido, filiacao, ref = linha

                dados = {
                    'negativa_spc': True if cobra == 'N' else False,
                    'profissao': profissao.title() if profissao else '',
                    'rg_numero': rg if profissao else '',
                    'apelido': apelido.title() if profissao else '',
                    'filiacao': filiacao.title() if profissao else '',
                    'ponto_referencia': ref.title() if profissao else ''
                }

                # selecionando participante
                participantes = self.env['sped.participante'].search(
                    [('cnpj_cpf_numero', '=', cpf)]
                )

                # Se não tem o participante continua
                if not participantes:
                    continue

                # Itera em participante no caso de cadastros duplicado no odoo
                for participante in participantes:

                    # Escreve dados
                    participante.write(dados)
                    participante.flush()
                    self.env.cr.commit()

                    print(
                        f'linha {arquivo_csv.line_num} de 291088 - '
                        f'{participante.cnpj_cpf} - {participante.nome}'
                    )
                    print(55 * '-')

                # Limpando cache
                participantes.invalidate_cache()

        except ValueError:
            print(ValueError)

        except TypeError:
            print(participante.cnpj_cpf)


executa('/tmp/dadosclientes.csv')
