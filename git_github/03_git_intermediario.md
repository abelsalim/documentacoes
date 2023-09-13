# Trabalhando com branchs

Uma branch pode ser definida como uma ramificação de um projeto, tendo como
finalidade criar uma variante que possibilite alterações livres do ramo
principal.

### Comandos básicos

| Comando | Descrição |
| :----- | :------- |
| `git checkout -b nome_da_branch` | Cria uma nova branch |
| `git checkout nome_da_branch` | Alterna para a branch selecionada |
| `git branch -l` | Lista as branchs existentes |
| `git branch -d nome_da_branch` | Apaga a branchs selecionada |


# Mesclando branchs

Ao realizar uma alteração em uma branch paralela onde o seu conteúdo deva ser
adicionada ao ramo principal, iremos utilizar o `merge`.

Suponhamos que estamos no ramo master e criamos uma ramificação chamada
refatoracao, após realizar as alterações voltaremos a branch principal com
`git checkout master`, para daí realizarmos a mescagem dos dados com o
`git merge refatoracao`, sendo 'refatoracao' o nome da branch paralela.

> Nota: ao realizar o merge, caso não seja necessário mais a utilização da
> branch 'refatoracao', é possível apagá-la com `git branch -d refatoracao`.


# Rebase ou Merge?

Primeiro, rebase é um comando que proporciona a mesma experiência que o merge,
pois ambos realizam a mesclagem de dados em diferentes ramos, porém o rebase
tem a capacidade de reescrever a 'linha temporal' dos commits que estão no ramo
principal da mesclagem. Portanto, embora seja melhor a utilização do rebase
quando em um projeto com poucos colaboradores, pode ser uma dor de cabeça
quando não, pois além de alterar a história linear dos commits, ele acaba
perdendo os 'metadados' dos commits, além de dificultar a compreensão de da
própria linha temporal.

A utilização do comando rebase segue a mesma sintaxe do merge quando o objetivo
for mesclar dois ramos, `git rebase nome_da_branch`.


# Clonando repositórios remotos

Para realizar a clonagem de repositórios remotos (realizar o download), basta
executarmos `git clone` seguido do repositório desejado.


# Sobre o push

Para realizar atualizações nos repositórios remotos 

