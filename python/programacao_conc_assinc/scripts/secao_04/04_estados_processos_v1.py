from time import sleep
from multiprocessing import Process


def funcao_2(valor, status):
    res = valor + 30 if status else valor + 40

    print(f'O resultado da função 2 é {res}')

    sleep(0.001)


def funcao_1(valor, status):
    res = valor + 10 if status else valor + 20

    print(f'O resultado da função 1 é {res}')

    sleep(0.001)


def main():
    valor = 100
    status = False

    p1 = Process(target=funcao_1, args=(valor, status))
    p2 = Process(target=funcao_2, args=(valor, status))

    # inicia e delimita fim dos processos
    [process.start() for process in (p1, p2)]
    [process.join() for process in (p1, p2)]


if __name__ == '__main__':
    main()