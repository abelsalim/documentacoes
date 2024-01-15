import csv


def escreve_no_banco(produto, dados):
    # Escreve dados
    produto.write(dados)
    produto.flush()
    self.env.cr.commit()

    # Limpando cache
    produto.invalidate_cache()


def atualiza(produto, eh_componente):
    # Dicionário para atualização
    dados = {'eh_componente_principal': eh_componente}

    # Atualiza as alterações
    escreve_no_banco(produto, dados)


def executa(arquivo):

    with open(arquivo, 'r') as arquivo_csv:
        arquivo_csv = csv.reader(arquivo_csv, delimiter='|')
        try:
            for indice, linha in enumerate(arquivo_csv):

                # Pula cabeçalho ou linha incompleta
                if len(linha) != 2:
                    continue

                codigo, eh_componente = linha

                # Converte em booleano
                eh_componente = True if eh_componente == 'S' else False

                # selecionando produto
                produtos = self.env['sped.produto'].search(
                    [('codigo', '=', codigo)]
                )

                # Sai se não tem o produtos
                if not produtos:
                    continue

                # Itera em produtos no caso de cadastros duplicado
                for produto in produtos:
                    # Variável de status
                    status = False

                    # Se não tem celular atualiza
                    if produto.eh_componente_principal != eh_componente:
                        atualiza(produto, eh_componente)
                        status = True


                    status = 'Atualizado!' if status else 'Não alterado!'

                    print(f'{indice} - {produto.codigo} - {status}')


        except ValueError:
            print(ValueError)

        except TypeError:
            print(f'Error - {produto.codigo}')


executa('/tmp/componenteprincipal.csv')
