import csv

from tqdm import tqdm


def escreve_dados_csv(cpf, celular):
    with open('/tmp/contatos_atualizado.csv', 'a') as csv_escrita:
        csv_escrita = csv.writer(csv_escrita, delimiter='|')

        celular = celular.__str__().translate(str.maketrans("", "", "./-() "))

        csv_escrita.writerows([[cpf, celular]])


def executa(arquivo):
    with open(arquivo, 'r') as arquivo_csv:
        arquivo_csv = csv.reader(arquivo_csv, delimiter='|')
        try:
            for linha in tqdm(arquivo_csv):
                cpf, telefone = linha

                cpf = f'#{cpf}'

                escreve_dados_csv(cpf, telefone)

        except ValueError:
            print(ValueError)


executa('/home/salim/contatos.csv')
