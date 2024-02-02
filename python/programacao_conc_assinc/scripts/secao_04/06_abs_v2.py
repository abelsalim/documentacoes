import time

from multiprocessing import Process


def processar():
    print('[', end='', flush=True)
    for _ in range(1, 11):
        print('#', end='', flush=True)
        time.sleep(1)

    print(']', end='', flush=True)


if __name__ == '__main__':
    ex = Process(target=processar)

    ex.start()
    ex.join()