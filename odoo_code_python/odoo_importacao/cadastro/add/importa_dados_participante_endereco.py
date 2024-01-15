import csv

from odoo.exceptions import ValidationError


def escreve_dados_csv(arquivo, linha):
    with open('/home/zenir/erros_enderecos.csv', 'a') as csv_escrita:
        csv_escrita = csv.writer(csv_escrita, delimiter='|')

        csv_escrita.writerows([linha])


def zerar_arquivo(arquivo):
    with open(arquivo, 'w') as arquivo:
        arquivo.truncate(0)


def trata_resultado_sql(lista_tupla):
    resultado =  list(filter(lambda x: x, map(lambda x: x[0], lista_tupla)))

    return resultado[0] if resultado else False


def executa(arquivo):
    zerar_arquivo('/home/zenir/erros_enderecos.csv')

    with open(arquivo, 'r') as arquivo_csv:
        arquivo_csv = csv.reader(arquivo_csv, delimiter='|')
        try:
            for linha in arquivo_csv:
                cpf, endereco, numero, bairro, cidade, uf, zr, cep = linha

                # selecionando participante
                participantes = self.env['sped.participante'].search(
                    [('cnpj_cpf_numero', '=', cpf)]
                )

                # Se não tem o participante continua
                if not participantes:
                    continue

                # Itera em participante no caso de cadastros duplicado no odoo
                for participante in participantes:

                    SQL = f"""
                        select
                            id

                        from
                            sped_municipio

                        where
                            immutable_unaccent(nome) = '{cidade.title()}'
                            and estado = '{uf}'
                    """

                    self.env.cr.execute(SQL)
                    dados = self.env.cr.fetchall()

                    municipio_id = trata_resultado_sql(dados)

                    zr = True if zr == 'S' else False

                    lista_condicional = [
                        participante.endereco == endereco,
                        participante.numero == numero,
                        participante.bairro == bairro,
                        participante.municipio_id.id == municipio_id,
                        participante.zona_rural == zr,
                        participante.cep.replace('-', '') == cep
                    ]

                    if all(lista_condicional):
                        continue

                    print(lista_condicional)

                    try:
                        # Escreve dados
                        participante.endereco = endereco
                        participante.numero = numero
                        participante.bairro = bairro
                        participante.municipio_id = municipio_id
                        participante.zona_rural = zr
                        participante.cep = cep

                    except ValidationError:
                        print(f'*** Error ***\n{linha}\n{70 * "+"}')
                        escreve_dados_csv(
                            '/home/zenir/erros_enderecos.csv',
                            linha
                        )
                        continue

                    self.env.cr.commit()

                    print(
                        f'linha {arquivo_csv.line_num} de 331060 - '
                        f'{participante.cnpj_cpf} - {participante.nome}'
                    )
                    print(70 * '-')
                    # breakpoint()

                # Limpando cache
                participantes.invalidate_cache()

        except ValueError:
            print(ValueError)

        except TypeError:
            print(participante.cnpj_cpf)


executa('/tmp/enderecos.csv')
