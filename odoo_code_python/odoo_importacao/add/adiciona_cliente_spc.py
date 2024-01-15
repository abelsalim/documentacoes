import csv


def escreve_dados_csv(dados, nome_arquivo):
    # Caminho padrão do arquivo
    diretorio = '/home/zenir'

    with open(f'{diretorio}/{nome_arquivo}', 'w', newline='') as arquivo_csv:
        cabecalho = ['cnpj_cpf']
        writer = csv.DictWriter(arquivo_csv, fieldnames=cabecalho, delimiter=',')

        print('Escrevendo dados!')

        writer.writeheader()
        writer.writerows(dados)

        print('Dados escritos!')


def executa(arquivo):
    with open(arquivo, 'r') as arquivo_csv:
        arquivo_csv = csv.reader(arquivo_csv, delimiter=';')
        try:
            lista_clientes_sem_registro = []
            for linha in arquivo_csv:
                cnpj_cpf = ''.join(linha)

                clientes = self.env['sped.participante'].search(
                    [('cnpj_cpf', '=', cnpj_cpf)]
                )

                # Sai se cliente não existe
                if not clientes:
                    lista_clientes_sem_registro.append({'cnpj_cpf': cnpj_cpf})
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

            nome_arquivo = arquivo.split('/')[-1]
            nome_arquivo = (
                f'clientes_nao_encontrados_{nome_arquivo.split(".")[0]}.csv'
            )

            escreve_dados_csv(lista_clientes_sem_registro, nome_arquivo)

        except ValueError:
            print(ValueError)

        except TypeError:
            print(cliente.nome)


executa('/tmp/spc/crateus.csv')
