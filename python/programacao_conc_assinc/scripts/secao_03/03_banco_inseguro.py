import time
import random

from threading import Thread
from programacao_conc_assinc.scripts.constants.threads import (
    ERRO_VALIDA_DADOS,
    SUCESSO_VALIDA_DADOS
)


class Conta:

    def __init__(self, saldo=0):
        self.saldo = saldo


def pega_duas_contas(contas):
    c1 = random.choice(contas)
    c2 = random.choice(contas)

    while c1 == c2:
        c2 = random.choice(contas)

    return c1, c2


def valida_banco(contas, total):
    atual = sum(conta.saldo for conta in contas)

    if atual != total:
        print(ERRO_VALIDA_DADOS.format(f'{atual:.2f}', f'{total:.2f}'))
    else:
        print(SUCESSO_VALIDA_DADOS.format(f'{atual:.2f}', f'{total:.2f}'))


def transferir(origem, destino, valor):
    if origem.saldo < valor:
        return

    # Remove valor da primeira conta
    origem.saldo -= valor

    time.sleep(0.001)

    # insere valor na segunda conta
    destino.saldo += valor


def criar_contas():
    return [
        Conta(saldo=random.randint(5_000, 10_000)),
        Conta(saldo=random.randint(5_000, 10_000)),
        Conta(saldo=random.randint(5_000, 10_000)),
        Conta(saldo=random.randint(5_000, 10_000)),
        Conta(saldo=random.randint(5_000, 10_000))
    ]


def servicos(contas, total):
    for _ in range(1, 10_000):
        c1, c2 = pega_duas_contas(contas)
        valor = random.randint(1, 100)
        transferir(c1, c2, valor)
        valida_banco(contas, total)


def main():
    contas = criar_contas()
    total = sum(conta.saldo for conta in contas)

    print('Iniciando transferência...')

    # As múltiplas threads ocasionam propositalmente o erro de incosistencia
    tarefas = [
        Thread(target=servicos, args=(contas, total)),
        Thread(target=servicos, args=(contas, total)),
        Thread(target=servicos, args=(contas, total)),
        Thread(target=servicos, args=(contas, total)),
        Thread(target=servicos, args=(contas, total)),
    ]

    # inicia e delimita fim das threads
    [tarefa.start() for tarefa in tarefas]
    [tarefa.join() for tarefa in tarefas]

    print('Transferências completas!')

    valida_banco(contas, total)


if __name__ == '__main__':
    main()
