def fibo(limite):
    valor = 0
    proximo = 1

    while valor < limite:
        # Retorne valor
        yield valor

        # Valor recebe 'proximo' e Proximo recebe 'valor' + 'proximo'
        valor, proximo = proximo, valor + proximo


def main():
    limite = 100
    numeros = [numero for numero in fibo(limite)]

    # converte os valores de numeros em string e utiliza o join para mescla-los
    print(', '.join(map(str, numeros)))


if __name__ == '__main__':
    main()
