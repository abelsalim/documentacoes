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

Suponha que estamos no ramo *master* e criamos uma ramificação chamada
*refatoracao*, após realizar as alterações voltaremos a branch principal com
`git checkout master`, para daí realizarmos a mesclagem dos dados com o
`git merge refatoracao`, sendo '*refatoracao*' o nome da branch paralela.

> Nota: ao realizar o merge, caso não seja necessário mais a utilização da
> branch 'refatoracao', é possível apagá-la com `git branch -d refatoracao`.


# Rebase ou Merge?

Primeiro, rebase é um comando que proporciona a mesma experiência que o merge,
pois ambos realizam a mesclagem de dados em diferentes ramos, porém o rebase
tem a capacidade de reescrever a 'linha temporal' dos commits que estão no ramo
principal da mesclagem. Portanto, embora seja melhor a utilização do rebase
quando em um projeto com poucos colaboradores, pode ser uma dor de cabeça
quando não, pois além de alterar a história linear dos commits, ele acaba
perdendo seus 'metadados', além de dificultar a compreensão de da própria linha
temporal.

A utilização do comando rebase segue a mesma sintaxe do merge quando o objetivo
for mesclar dois ramos, `git rebase nome_da_branch`.


# Clonando repositórios remotos

Para realizar a clonagem de repositórios remotos (realizar o download), basta
executarmos `git clone` seguido do repositório desejado.

```
git clone https://github.com/abelsalim/documentacoes.git
```

# Subindo atualizações para o repositório remoto

Para realizar atualizações nos repositórios remotos podemos utilizar o operador
`push`, onde o mesmo irá literalmente empurrar os dados (realizar upload) para
o repositório remoto executando `git push`.


# Sincronizando repositório local com o remoto

Para realizar a sincronização com o repositório remoto execute `git pull`.


# Utilizando o comando `fetch`

O comando `fetch` tem a funcionalidade de realizar o download do conteúdo
remoto e não mesclar de imediato, ficando passível ao comando do usuário.
Quando realizado, é possível mesclar com os dados locais utilizando o comando
`rebase`.

Em uma linha do tempo cronológica seria executado primeiro `git fetch`, onde
este realizaria o download do conteúdo remoto, seguido de `gir rebase` para
então realizar a mesclagem dos dados.

Mas porque utilizar dois comandos (`fetch` e `rebase`) e não um (`pull`)?
Bom, tem situações onde será necessário realizar a sincronização mesmo quando
sua base (local) esteja com commits a frente do repositório remoto.

Digamos que em um projeto dois indivíduos pegaram uma demanda que requer duas
alterações, porém o __primeiro indivíduo__ deve validar a
__primeira alteração__ e realizar o commit, para que o __segundo indivíduo__
baixe as atualizações e possa validar a __segunda alteração__. Sendo esta uma
tarefa de prioridade, deve ser realizada urgentemente, ou seja, ambas as
alterações serão feitas simultaneamente, porém, o __segundo indivíduo__
realizou o commit da sua alteração para então realizar a mesclagem, com isso
sua base se tornou diferente da remota ao estar com dados a mais (segunda
alteração) e a menos (primeira alteração) em relação ao repositório central.

Nesse tipo de situação o `git pull` não realizaria a mesclagem dos dados pois
existe um commit local que não se encontra no remoto, portando essa seria uma
situação para utilizar o `git fetch` seguido do `git rebase`.


# Distinguindo repositórios bare e non-bare

Quando criamos um repositório com o comando `git init` estamos definindo um
*non-bare* repositório, ou seja, um repositório passível a edição direta pelo
usuário. Logo um *bare* repositório é criado com o comando `git init --bare`, e
tem a finalidade de ser um repositório mãe (como os hospedados no github), ou
seja, não passíveis à edição! Com isso, os repositórios *bare* servem para
compartilhamento centralizado.


# Utilizando tags

A utilização de tags no git serve para criar versões estáticas do projetos, ou
seja, em situações onde devo continuar o desenvolvimento da minha aplicação,
porém devo fornecer uma versão estável da mesma.

Sua utilização baseia-se no comando `git tag nome_da_tag`. Com isso será criada
uma tag onde os dados daquela linha temporal (commits) serão estáticos para
clonar ou realizar downloads.
