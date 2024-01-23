# Esse arquivo contém um dicionário de termos sobre programação assíncrona e concorrente

## GIL - Global Interpreter Lock
O GIL é um mecanismo de controle de execução do CPython, e o mesmo tem a
finalidade de estabelecer uma execução sequencial para as threads afim de
manter a integridade dos dados em execução. Com sua utilização é proporcionado
uma facilidade para o desenvolvimento já que o mesmo evita erros complexos de
concorrência, porém torna a execução mais 'lerda' ao limitar o desempenho do
sistema e consequentemente impede o aproveitamento total da concorrência.

> Nota: Uma solução seria a utilização da lib multiprocessing para 'escapar' do
> GIL.

## Threads
Trata-se de fragmentar uma linha de processamento em múltiplas linhas de
execução, onde possibilita a execução simultânea de coisas que não precisam ser
executadas de forma sequencial.

> Nota: o método join do objeto Thread utiliza o o 'Main Thread Block', onde
> o mesmo não permite a execução de qualquer comando posterior sem a devida
> finalização da thread instanciada.

### Ciclo de vida de uma thread

* __New__: Indica uma nova instância;
* __Ready__: Indica que a mesma está pronta;
* __Running__: Indica que esta em execução;
* __Blocked__: Indica que a mesma teve sua execução bloqueada;
* __Terminated__: Indica que foi finalizada;

### Agendador - Scheduler
Um sistema operacional possui um módulo ou classe responsável por gerir os
processos, com isso, o mesmo necessita de um 'auxiliar', onde este é conhecido
como _scheduler_. Sua finalidade é manter o fluxo adequado e sem
'engarrafamentos' na execução dos processos/threads.

Para essas funcionalidades são utilizados os chamados '__context switch__' onde
ele é responsável por salvar o estado do processo/thread em execução e carregar
as informações do próximo da fila.

## Processos
Processo nada mais é do que uma instância parcial ou não de uma programa como
um todo, portanto um processo ou um aglomerado de processos compõem um programa
computacional.