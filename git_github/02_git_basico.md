# Ciclo de vida dos status de arquivos no GIT

Os ciclos/estágios de arquivos pertencentes a um repositório git são
'etiquetados' com rótulos que indicam suas situações em relação ao repositório.
Existem quatro fases:

* __Untracked__: Representa os arquivos adicionado a um repositório
(independente do arquivo ser anterior ou posterior a criação do repositório),
onde os mesmos *__ainda não são rastreados__*.

* __Tracked__: Representa os arquivos que *__passaram a ser rastreados__* pelo
git através do comando `git add`.

* __Modified__: Representa os arquivos já rastreados, porém *__que sofreram__*
*__algum tipo de modificação__*.

* __Staged__: Representa os arquivos 'prontos', ou seja, os *__arquivos já__*
*__commitados__* através do comando `git commit`.


# O que é gitignore?

Existem situações em que alguns arquivos não devem ser rastreados, como
arquivos de configurações do vscode por exemplos (a pasta _.vscode_).

Para tornar um arquivo, pasta ou extensões irrastreáveis, basta criar um
arquivo `.gitignore` na raiz do projeto com os respectivos nomes:

```
# todos os diretórios com a nomenclatura citada
.vscode

# todos os diretórios e subdiretórios com a nomenclatura citada
**__pycache__

# todos os arquivos com a extensões citada
*.pyc
```


# Arquivo de configurações do repositório atual

O arquivo de configuração do repositório atual está contido no arquivo `config`
que se encontra na pasta `.git` do repositório em questão.

Ao abrir o arquivo de configuração poderá ser encontrado os seguintes dados:

```
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
```

Entretanto a sessão [User] não foi determinada, o que impossibilita a
identificação do usuário que realizou as alterações vigentes e também a 
realização de quaisquer commit. Para definirmos essas instâncias
configuracionais são necessários apenas os parâmetros `user.name` e `user.mail`
no comando `git config`.

```
git config user.name 'abelsalim'
git config user.mail 'abelsalim@proton.me'
```

Ao realizar tais alterações com os comandos acima, o arquivo `.git/config`
ficará da seguinte maneira:

```
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[user]
        name = abelsalim
        email = abelsalim@proton.me
```

Sempre que iniciar um repositório será necessário adicionar suas credenciais,
visto que as informações não foram colocadas como globais. Para isso basta
adicionarmos as flags `--global`:

```
git config --global user.name 'abelsalim'
git config --global user.mail 'abelsalim@proton.me'
```


# Funcionamento do commit e consulta ao histórico do projeto

Ao realizar um commit é necessário repassar um pequeno trecho que descreva a
alterações realizadas. Cada commit gera um hash, portanto, o mesmo se torna 
único por versão mesmo que dois commits tenham a mesma descrição.

Ao realizar tais mudanças e publica-las com o commit, será possível visualizar
os commits e alterações com o comando `git log`. Sua saída no terminal é a 
seguinte:

```
commit 63235167fdd26d722d72b2ee6a536d560d6ddf53
Author: abelsalim <salim@archlinux.localhost>
Date:   Sat Sep 9 09:03:16 2023 -0300

    [ADD] Introducao - GIT E GITHUB
```

Onde a primeira linha informa o hash do commit seguida do autor (nome e email),
data da publicação e por fim a descrição das alterações.


# Comandos básicos

| Comando | Descrição |
| :----- | :------- |
| `git init` | Inicia um repositório |
| `git add` | Torna um arquivo untracked em tracked |
| `git status` | Mostra um status dos arquivos (untracked, trackeg e modified) |
| `git commit` | Torna um arquivo tracked em staged |
| `git log` | Mostra todos os commits realizados de forma resumida |


# Variações do `git log`

| Comando | Descrição |
| :----- | :------- |
| `git log -2` | Mostra apenas os últimos dois commits realizados |
| `git log --oneline` | Mostra todos os commits realizados de forma resumida |
| `git log --oneline -2` | Mostra apenas os últimos dois commits realizados de forma resumida |
| `git log --after="2023-09-9"` | Mostra apenas os commits realizados após o dia "2023-09-9" |
| `git log --before="2023-09-9"` | Mostra apenas os commits realizados antes do dia "2023-09-9" |
| `git log --after="3 week ago"` | Mostra apenas os commits realizados após 1 semana atrás |
| `git log --since="3 days ago"` | Mostra apenas os commits realizados desde 3 dias atrás |
| `git log --author="abelsalim"` | Mostra apenas os commits realizados pelo autor 'abelsalim' |


# Retornando para um commit

O comand `git checkout` é um comando que possibilita realizar diversas coisas,
uma delas é poder retornar a um commit específico através do hash único.
Por exemplo, podemos listar os logs de forna resumida com o
`git log --oneline`, escolher o commit para retorno através da descrição e por
fim utilizar o `gir checkout d1c7fab` ('d1c7fab' é o hash do commit), onde o
mesmo iria retornar para o commit específico.

Caso deseje retornar ao padrão (último commit realizado), basta utilizar a
branch padrão como base, ou seja, `git checkout master`.

> Nota: para listar as branchs disponíveis basta executar `git branch -l`


# Renomeando arquivos ou pastas

Quando renomeamos um arquivo monitorado devemos executar o `git mv` repassando
como parâmetro o arquivo atual (com nome antigo) e o nome novo. Ao renomear é
realizado a remoção e criação de um mesmo arquivo, portando será necessário
realizar um novo commit.


# Removendo arquivos ou pastas

Para remover um arquivo no git basta executar o `git rm` repassando como
parâmetro o arquivo para deleção. Ao remover o arquivo será necessário realizar
um novo commit.


# Verificando diferenças entre os commits

Para verificar o que foi alterado com os commits ou mesmo antes deles, podemos
utilizar o `git diff`. Ao acrescentar o parâmetro `--staged` será comparado os
arquivos no status 'staged' com os arquivos de status 'tracker', ou seja,
compara os arquivos adicionados - `git add` - com os arquivos do último
commit.

Para comparar as alterações do commit atual com o commit 'x', basta executar
`git diff d1c7fab`, sendo o 'd1c7fab' as iniciais do hash comparado.

Caso queira analisar as alterações em commits específicos, podemos executar
`git diff d1c7fab..6323516` sendo 'd1c7fab' o commit mais antigo e '6323516' o
mais atual.


# Desfazendo alterações

### Alterações relacionadas aos commits - staged

Caso queira alterar a descrição do commit execute `git commit --amend`. O mesmo
serve para casos em que um arquivo deva ser adicionado juntamente com o commit
anterior, por exemplo, digamos que realizei o commit e logo vi que será
necessário um novo arquivo, porém todos devem habitar o mesmo commit.

Para resolver essa situação, basta criarmos normalmente o arquivo, adicioná-lo
com `git add` e realizar o commit com o parâmetro `--amend`.

### Alterações relacionadas aos arquivos - modified

Para desfazer alterações em arquivos antes do 'staged' basta utilizar o comando
`git checkout` repassando o nome do arquivo como parâmetro.

Caso tenha um conjunto de arquivos modificados e deseje retornar todos para a
estado do último commit basta executar `git reset HEAD --hard` onde o 'HEAD'
indica o commit 'cabeça' (principal, último) e '--hard' indica tudo.

### Alterações relacionadas aos commits - descartar atual

Para resetar configurações gerais descartando tudo, basta aplicar o
`git reset HEAD^ --hard`, onde o '^' indica o penúltimo commit realizado (caso
esteja utilizando um shell como o zsh, basta clicar tab duas vezes ao digitar
`git reset` que ficará visível as nomenclaturas utilizáveis).

# Removendo arquivos do staged

Em uma situação onde o arquivo teste.txt foi adicionado ao 'staged' com o
`git add teste.txt` e posteriormente foi visto que aquela alteração não iria
entrar no commit vigente, temos duas opões, sendo a primeira remover todos os
arquivos adicionado ao 'staged' com o comando `git restore --staged` ou apenas
um em específico passando o nome do arquivo como parâmetro para o mesmo
comando.
