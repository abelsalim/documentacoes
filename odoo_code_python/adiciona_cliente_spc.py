import csv


def executa(arquivo):
    with open(arquivo, 'r') as arquivo_csv:
        arquivo_csv = csv.reader(arquivo_csv, delimiter=';')
        try:
            for linha in arquivo_csv:
                cnpj_cpf, contrato = linha

                clientes = self.env['sped.participante'].search(
                    [('cnpj_cpf', '=', cnpj_cpf)]
                )

                # Sai se cliente não existe
                if not clientes:
                    continue

                for cliente in clientes:
                    # Sai se cliente já está negativado
                    if cliente.cliente_negativado_spc:
                        continue

                    print(
                        f'{cliente.nome} - {cliente.cnpj_cpf} - '
                        f'{cliente.cliente_negativado_spc}'
                    )

                    # Atribui e grava no banco
                    cliente.cliente_negativado_spc = True
                    cliente.flush()
                    self.env.cr.commit()

                    print(
                        f'{cliente.nome} - {cliente.cnpj_cpf} - '
                        f'{cliente.cliente_negativado_spc}'
                    )

                    print(55 * '-')

                    cliente.invalidate_cache()

        except ValueError:
            print(ValueError)

        except TypeError:
            print(cliente.nome)


executa('/tmp/spc.csv')
