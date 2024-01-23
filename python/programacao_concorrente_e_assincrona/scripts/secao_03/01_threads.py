import time

from threading import Thread


def contar(o_que, numero, tempo):
    for n in range(1, numero + 1):
        print(f'{n} {o_que}(s)...')
        time.sleep(tempo)


def thread_multiplas():
    threads = [
        Thread(target=contar, args=('mosquito', 12, 1)),
        Thread(target=contar, args=('cachorro', 10, 2)),
        Thread(target=contar, args=('elefante', 11, 1)),
    ]

    # Adiciona todas as threads de forma sequencial na pool de execução
    [th.start() for th in threads]

    print('Print demostrativo')

    # Indica o ponto onde não será possível prosseguir sem a conclusão da
    # thread iniciada
    [th.join() for th in threads]

    print('Finalizado!')


def thread_simples():
    th = Thread(target=contar, args=('elefante', 10))

    # Adiciona a thread na pool de execução
    th.start()

    print('Print demostrativo')

    # Indica o ponto onde não será possível prosseguir sem a conclusão da
    # thread iniciada
    th.join()

    print('Finalizado!')


if __name__ =='__main__':
    # thread_simples()
    thread_multiplas()
