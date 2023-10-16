import csv

from tqdm import tqdm


def escreve_no_banco(participante, dados):
    # Escreve dados
    participante.write(dados)
    participante.flush()
    self.env.cr.commit()

    # Limpando cache
    participante.invalidate_cache()


def atualiza(indice, participante, celular):
    # Dicionário para atualização
    dados = {'celular': celular}

    # Atualiza as alterações
    escreve_no_banco(participante, dados)


def cadastro_completo(participante):
    lista_condicional_tem_celular = [
        participante.celular,
        len(participante.celular) == 15,
        participante.celular[2:3].__str__() == '9'
    ]

    # Se existe o celular e tem 15 dígitos continua
    if all(lista_condicional_tem_celular):
        return True


def executa(arquivo):
    with open(arquivo, 'r') as arquivo_csv:
        arquivo_csv = csv.reader(arquivo_csv, delimiter='|')
        try:
            for indice, linha in enumerate(arquivo_csv):
                cpf, telefone = linha

                # Formata telefone padão odoo
                celular = f'({telefone[:2]}) 9{telefone[3:7]}-{telefone[7:11]}'

                # selecionando participante
                participante = self.env['sped.participante'].search(
                    [('cnpj_cpf_numero', '=', cpf)]
                )

                # Se ddd inicia com 0
                if telefone[0:1].__str__() == '0':
                    continue

                # Se não tem o participante continua
                if not participante:
                    continue

                # Se o celular cadastrado é o mesmo do odoo continua
                elif celular == participante.celular:
                    continue

                # Se não tem celular cadastrado então atualiza o mesmo
                elif not participante.celular:
                    atualiza(indice, participante, celular)

                # Se existe o celular e tem 15 dígitos pode continuar
                elif cadastro_completo(participante):
                    continue

                # Se existe o celular mas está fora do padrão
                elif not cadastro_completo(participante):
                    # Dicionário para atualização
                    dados = {'celular': False}

                    # Escreve dados
                    escreve_no_banco(participante, dados)

                    atualiza(indice, participante, celular)

                print(
                    f'linha {indice} de 291.090 - {participante.cnpj_cpf} - '
                    f'{participante.celular} - {celular}'
                )

        except ValueError:
            print(ValueError)

        except TypeError:
            print(participante.celular)


executa('/tmp/cpftelefone.csv')
