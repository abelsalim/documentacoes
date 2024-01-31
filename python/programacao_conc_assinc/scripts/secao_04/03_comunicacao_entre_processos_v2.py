from multiprocessing import Process, JoinableQueue


def Inicia(queue):
    queue.put('Abel')


def finaliza(queue):
    msg = queue.get()
    print(f'{msg} Salim')

    queue.task_done()


def main():
    # JoinableQueue tem as mesmas funcionalidades da Queue utilizadas em
    # threads, mas seu nome é diferenciado pois em multiprocessing também
    # existe uma classe Queue, porém sem os métodos 'task_done' e 'join'.
    queue = JoinableQueue()

    # Instanciando os processos
    p1 = Process(target=Inicia, args=(queue,))
    p2 = Process(target=finaliza, args=(queue,))

    # inicia e delimita fim dos processos
    [process.start() for process in (p1, p2)]
    [process.join() for process in (p1, p2)]


if __name__ == '__main__':
    main()
