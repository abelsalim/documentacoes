import csv

from tqdm import tqdm

DDD = [
    61, 62, 64, 65, 66, 67, 82, 71, 73, 74, 75, 77, 85, 88, 98, 99, 83, 81, 87,
    86, 89, 84, 79, 68, 96, 92, 97, 91, 93, 94, 69, 95, 63, 27, 28, 31, 32, 33,
    34, 35, 37, 38, 11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 24, 41, 42, 43,
    44, 45, 46, 51, 53, 54, 55, 47, 48, 49
]

RETORNO = 'linha {} de 291.090 - {} - {} - {} - {}'


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

def escreve_dados_csv(cpf, celular):
    with open('/tmp/nova_lista.csv', 'a') as csv_escrita:
        csv_escrita = csv.writer(csv_escrita, delimiter='|')

        celular = celular.__str__().translate(str.maketrans("", "", "./-() "))

        csv_escrita.writerows([[cpf, celular]])


def zerar_arquivo(nome_arquivo):
    with open(nome_arquivo, 'w') as arquivo:
        arquivo.truncate(0)


def executa(arquivo):
    zerar_arquivo('/tmp/nova_lista.csv')

    with open(arquivo, 'r') as arquivo_csv:
        arquivo_csv = csv.reader(arquivo_csv, delimiter='|')
        try:
            for indice, linha in enumerate(arquivo_csv):
                cpf, telefone = linha

                # Formata telefone padão odoo
                celular = f'({telefone[:2]}) 9{telefone[3:7]}-{telefone[7:11]}'

                # selecionando participante
                participantes = self.env['sped.participante'].search(
                    [('cnpj_cpf_numero', '=', cpf)]
                )

                # Se não tem o participante continua
                if not participantes:
                    continue

                # Se ddd não for válido
                elif int(telefone[0:2]) not in DDD:
                    continue

                # Itera em participante no caso de cadastros duplicado no odoo
                for participante in participantes:

                    # Se não tem celular atualiza
                    if not participante.celular:
                        mensagem = 'sem celular'
                        retorno = RETORNO.format(
                            indice,
                            participante.cnpj_cpf,
                            participante.celular,
                            celular,
                            mensagem
                        )
                        print(retorno)

                        atualiza(indice, participante, celular)
                        escreve_dados_csv(cpf, celular)

                    # Se o celular cadastrado é o mesmo do odoo continua
                    elif celular == participante.celular:
                        escreve_dados_csv(cpf, celular)
                        continue

                    # Se existe o celular e tem 15 dígitos pode continuar
                    elif cadastro_completo(participante):
                        escreve_dados_csv(cpf, participante.celular)
                        continue

                    # Se existe o celular mas está fora do padrão
                    elif not cadastro_completo(participante):
                        mensagem = 'celular fora do padrão'
                        retorno = RETORNO.format(
                            indice,
                            participante.cnpj_cpf,
                            participante.celular,
                            celular,
                            mensagem
                        )
                        print(retorno)

                        # Dicionário para atualização
                        dados = {'celular': False}

                        # Escreve dados
                        escreve_no_banco(participante, dados)

                        atualiza(indice, participante, celular)
                        escreve_dados_csv(cpf, celular)

        except ValueError:
            breakpoint()
            print(ValueError)

        except TypeError:
            print(participante.celular)


executa('/tmp/cpftelefone.csv')
