import ctypes

from time import sleep
from multiprocessing import RLock, Value, Process
from programacao_conc_assinc.scripts.constants.multiprocessing import (
    O_RESULTADO_DA_FUNCAO_X
)


def funcao_2(valor, status, lock):
    with lock:
        if status.value:
            res = valor.value + 30
            status.value = False

        else:
            res = valor.value + 40
            valor.value = 400
            status.value = True

    print(O_RESULTADO_DA_FUNCAO_X.format(2, res))

    sleep(0.001)


def funcao_1(valor, status, lock):
    with lock:
        if status.value:
            res = valor.value + 10
            status.value = False

        else:
            res = valor.value + 20
            valor.value = 200
            status.value = True

    print(O_RESULTADO_DA_FUNCAO_X.format(1, res))

    sleep(0.001)


def main():
    lock = RLock()
    valor = Value(ctypes.c_int, 100)
    status = Value(ctypes.c_bool, False)

    p1 = Process(target=funcao_1, args=(valor, status, lock))
    p2 = Process(target=funcao_2, args=(valor, status, lock))

    # inicia e delimita fim dos processos
    [process.start() for process in (p1, p2)]
    [process.join() for process in (p1, p2)]


if __name__ == '__main__':
    main()