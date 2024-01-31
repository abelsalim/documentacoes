from multiprocessing import Pipe, Process


def Inicia(conn):
    conn.send('Abel')


def finaliza(conn):
    msg = conn.recv()
    print(f'{msg} Salim')


def main():
    # Instanciando um canal duplex, o que significa que ambas as conexoes podem
    # 'falar' e 'ouvir'.
    connection_1, connection_2 = Pipe(duplex=True)

    # Instanciando os processos
    p1 = Process(target=Inicia, args=(connection_1,))
    p2 = Process(target=finaliza, args=(connection_2,))

    # inicia e delimita fim dos processos
    [process.start() for process in (p1, p2)]
    [process.join() for process in (p1, p2)]


if __name__ == '__main__':
    main()
