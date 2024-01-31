from multiprocessing import Process, current_process

print(f'Processo python: {current_process().name}')

def funcao_qualquer():
    print('hahaha')


def main():
    process = Process(target=funcao_qualquer, name='exemplificacao')

    print(f'Nome processo: {process.name}.')

    process.start()

    input()

    process.join()


if __name__ == '__main__':
    main()