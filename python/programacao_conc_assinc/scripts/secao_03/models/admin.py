import time
import random

from threading import RLock
from programacao_conc_assinc.scripts.secao_03.models.conta import Conta
from programacao_conc_assinc.scripts.constants.threads import (
    ERRO_VALIDA_DADOS,
    SUCESSO_VALIDA_DADOS,
)


class Admin(Conta):

    def __init__(self) -> None:
        self.lock = RLock()

    def valida_banco(self, contas, total):
        with self.lock:
            atual = sum(conta.saldo for conta in contas)

        if atual != total:
            print(ERRO_VALIDA_DADOS.format(f'{atual:.2f}', f'{total:.2f}'))
        else:
            print(SUCESSO_VALIDA_DADOS.format(f'{atual:.2f}', f'{total:.2f}'))

    def transferir(self, origem, destino, valor):
        if origem.saldo < valor:
            return

        with self.lock:
            # Remove valor da primeira conta
            origem.saldo -= valor

            time.sleep(0.001)

            # insere valor na segunda conta
            destino.saldo += valor

    def captura_duas_contas(self, contas):
        # Captura as contas de forma aleatória
        c1 = random.choice(contas)
        c2 = random.choice(contas)

        # Permanece no loop enquanto as contas capturadas forem iguais
        while c1 == c2:
            c2 = random.choice(contas)

        return c1, c2

    def servicos(self, contas, total):
        for _ in range(1, 1_000):
            # Captura um par de contas distintas por vez
            c1, c2 = self.captura_duas_contas(contas)

            # Delimita valor da transferência
            valor = random.randint(1, 100)

            # Método de tranferência dos valores
            self.transferir(c1, c2, valor)

            # método simples que compara valor total
            self.valida_banco(contas, total)

    def criar_contas_aleatorias(self):
        return [
            Conta(saldo=random.randint(5_000, 10_000)),
            Conta(saldo=random.randint(5_000, 10_000)),
            Conta(saldo=random.randint(5_000, 10_000)),
            Conta(saldo=random.randint(5_000, 10_000)),
            Conta(saldo=random.randint(5_000, 10_000))
        ]