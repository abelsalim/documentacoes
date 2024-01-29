from threading import Thread
from programacao_conc_assinc.scripts.secao_03.models.admin import Admin
from programacao_conc_assinc.scripts.constants.threads import (
    STATUS_INICIA_TRANSFERENCIA,
    STATUS_FINALIZA_TRANSFERENCIA
)


def main(objeto_admin):
    # Gera constas 'aleatórias'
    contas = objeto_admin.criar_contas_aleatorias()

    # Utiliza o lock nas threads
    with objeto_admin.lock:
        total = sum(conta.saldo for conta in contas)

    print(STATUS_INICIA_TRANSFERENCIA)

    # Gera uma lista de threads
    threads = [
        Thread(target=objeto_admin.servicos, args=(contas, total)),
        Thread(target=objeto_admin.servicos, args=(contas, total)),
        Thread(target=objeto_admin.servicos, args=(contas, total)),
        Thread(target=objeto_admin.servicos, args=(contas, total)),
        Thread(target=objeto_admin.servicos, args=(contas, total))
    ]

    # inicia e delimita fim das threads
    [tarefa.start() for tarefa in threads]
    [tarefa.join() for tarefa in threads]

    print(STATUS_FINALIZA_TRANSFERENCIA)

    objeto_admin.valida_banco(contas, total)


if __name__ == '__main__':
    # Instanciando objeto central
    objeto_admin = Admin()

    main(objeto_admin)
