# Esse arquivo contém um dicionário de termos que aborda o assunto

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
Trata-se fragmentar uma linha de processamento em múltiplas linhas de execução,
onde possibilita a execução simultânea de coisas que não precisão ser
executadas de forma sequencial.

## Processos
Processo nada mais é do que uma instância parcial ou não de uma programa como
um todo, ou seja, um processo ou um aglomerado de processos compõem um programa
computacional.