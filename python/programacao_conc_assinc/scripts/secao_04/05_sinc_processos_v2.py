import ctypes

from multiprocessing import RLock, Value, Process
from programacao_conc_assinc.scripts.constants.multiprocessing import (
    SALDO_INICIAL,
    SALDO_FINAL
)


def sacar(saldo, lock):
    with lock:
        for _ in range(10_000):
            saldo.value -= 1


def depositar(saldo, lock):
    with lock:
        for _ in range(10_000):
            saldo.value += 1


def realizar_transacoes(saldo, lock):
    p1 = Process(target=depositar, args=(saldo, lock))
    p2 = Process(target=sacar, args=(saldo, lock))

    # inicia e delimita fim dos processos
    [process.start() for process in (p1, p2)]
    [process.join() for process in (p1, p2)]


def main():
    # define o lock
    lock = RLock()

    # Define o saldo com ctype
    saldo = Value(ctypes.c_int, 100)

    print(SALDO_INICIAL.format(saldo.value))

    for _ in range(10):
        realizar_transacoes(saldo, lock)

    print(SALDO_FINAL.format(saldo.value))


if __name__ == '__main__':
    main()
