import csv


def escreve_no_banco(produto, dados):
    # Escreve dados
    produto.write(dados)
    produto.flush()
    self.env.cr.commit()

    # Limpando cache
    produto.invalidate_cache()


def atualiza(produto):
    # Dicionário para atualização
    dados = {'eh_componente_principal': True}

    # Atualiza as alterações
    escreve_no_banco(produto, dados)


def executa(arquivo):

    with open(arquivo, 'r') as arquivo_csv:
        arquivo_csv = csv.reader(arquivo_csv, delimiter='|')
        try:
            for indice, codigo in enumerate(arquivo_csv):

                # selecionando produto
                produtos = self.env['sped.produto'].search(
                    [('codigo', 'in', codigo)]
                )

                # Se não tem o participante continua
                if not produtos:
                    continue

                # Itera em participante no caso de cadastros duplicado no odoo
                for produto in produtos:
                    # Variável de status
                    status = False

                    # Se não tem celular atualiza
                    if not produto.eh_componente_principal:
                        atualiza(produto)
                        status = True

                    status = 'Atualizado' if status else 'Não alterado'

                    print(f'{indice} - {produto.codigo} - {status}')


        except ValueError:
            print(ValueError)

        except TypeError:
            print(f'Error - {produto.codigo}')


executa('/tmp/componenteprincipal.csv')
