import time

# from concurrent.futures.thread import ThreadPoolExecutor as Executor
from concurrent.futures.process import ProcessPoolExecutor as Executor
from programacao_conc_assinc.scripts.constants.multiprocessing import (
    O_RESULTADO
)

def processar():
    print('[', end='', flush=True)
    for _ in range(1, 11):
        print('#', end='', flush=True)
        time.sleep(1)

    print(']', end='', flush=True)

    return 24


if __name__ == '__main__':
    with Executor() as executor:
        future = executor.submit(processar)

    print(O_RESULTADO.format(future.result()))
