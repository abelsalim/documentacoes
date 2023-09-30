# GitHub x ssh
Podemos cadastrar chaves ssh para realizar o download/upload contínuo de de
dados para os repositórios através da autenticação ssh. Essa é uma prática
segura e ágil de se trabalhar, visto que uma vez autenticado com ssh, não será
necessário redigitar a senha em cada push.

### Criando chave ssh
Antes de clonarmos os repositórios, devemos inicialmente gerar os pares de
chaves ssh, e vincularmos a chave pública ao github.

### Gerando a chave ssh
```
ssh-keygen -b 4096
```

### Copiando chave ssh pública
Agora vamos 'printar' o conteúdo do arquivo que contém a chave gerada e copiar
para então adicionar ao github.
```
cat ~/.ssh/id_rsa.pub
```

Para adicionar uma chave ssh ao seu github siga o artigo publicado no
[GitHub Docs](https://docs.github.com/pt/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).


# Trabalhando com repositórios remotos

Quando um repositório é clonado, ou seja, sua origem é um __bare__ (local ou
remoto), a cópia (__non-bare__) possui uma associação automática com o
__bare__, com isso um push ou pull pode ser realizado sem muitos problemas.

Em casos onde o repositório foi inicializado localmente (__non bare__) e
posteriormente associado a um __bare__ (local ou remoto), será necessário
adicionar um `remote` ao seu repositório.

Um *remote* nada mais é do que o endereço para o __bare__ repositório,
possibilitando assim realizar o push pós commit caso o usuário tenha acesso
de contribuidor ou administrador. Cada `remote` é nomeado, pois um mesmo
repositório pode ter diversos remotes (Refere-se a casos onde você colabora na
versão community e também em uma versão própria regidas apenas por branchs
diferentes).

Com isso, a utilização de remotes no git segue a sintaxe
`git remote add nome_do_remote endereco_do_remote`. Exemplo:

```
git remote add origin https://github.com/abelsalim/documentacoes.git
```

No exemplo acima o repositório '*documentacoes*' foi nomeado como *origin* ao
repositório atual.

Consequentemente a realização dos comandos push e pull não seguem mais a mesma
sintaxe, pois como o remote foi adicionado manualmente ambos tem que serem
apontados também na execução dos comandos. A sintaxe para execução é
`git push/pull nome_do_remote branch_desejada`. Exemplo:

```
git push/pull origin master
```

No exemplo acima o foi realizado um push/pull no remote *origin* e branch
*master*.


# Resolução de conflitos

É comum termos conflitos quando trabalhamos em um projeto em conjunto, mesmo
quando em simples arquivos `__init__.py`. Acontece que é chato tratar conflitos
quando não se sabe por onde começar, por isso vou simular um projeto local
através de um *bare repositório* para entendermos na prática como agir nessas
situações.

### Criando um bare repositório

Inicialmente vamos criar uma pasta chamada *projeto_01*, entrar dentro dela e
inicializar o bare repositório.

```
# Criar pasta 'projeto_01'
mkdir projeto_01

# Acessar a pasta 'projeto_01'
cd projeto_01

# Inicializando bare repositório
git init --bare
```

### Clonando o bare repositório

Com o bare repositório inicializado, vamos clona-lo duas vezes para simular
dois indivíduos trabalhando simultaneamente.

```
# Voltando um nível
cd ..

# Clonando o projeto_01 para o desenvolvedor_01
git clone ./projeto_01 ./desenvolvedor_01

# Clonando o projeto_01 para o desenvolvedor_02
git clone ./projeto_01 ./desenvolvedor_02
```

> Nota: Como criamos o bare repositório do zero, será reportado que o mesmo
> está vazio, mas podemos ignorar a mensagem visto que a mesma não irá
> influenciar negativamente.

### Alterações do 'desenvolvedor_01'

Como o projeto está na fase inicial, o 'desenvolvedor_01' decidiu criar um
arquivo README.md como o 'help' inicial sobre o projeto.

```
# Acessar o repositório do desenvolvedor_01
cd desenvolvedor_01

# Adicionando nome de usuário ao repositório
git config user.name 'desenvolvedor_01'

# Adicionando email de usuário ao repositório
git config user.email 'desenvolvedor_01@proton.me'

# Criar arquivo README.md
touch README.md

# Acessar arquivo e altera-lo
vim README.md {
    # Este readme é referente ao 'projeto_01'
}

# Tornando o arquivo 'README.md' rastreável
git add README.md

# Realizando commit do arquivo
git commit -m 'Primeiro README.md'

# Realizando o push para o bare repositório
git push origin master
```

### Alterações do 'desenvolvedor_02'

Como o projeto está na fase inicial, o 'desenvolvedor_02' também decidiu criar
um arquivo README.md como o 'help' inicial sobre o projeto, porém, a falta de
comunicação entre ambos impossibilitou prevenir o conflito com um simples
`git pull` antes de realizar alterações no mesmo arquivo.

Em resumo, quando o 'desenvolvedor_02' iniciou sua jornada no 'projeto_01' o
'desenvolvedor_01' já havia 'subido' suas alterações tornando o repositório do
*desenvolvedor_02* atrasado.

Segue abaixo os passos iniciais realizado pelo 'desenvolvedor_02'.

```
# Acessar o repositório do desenvolvedor_02
cd desenvolvedor_02

# Adicionando nome de usuário ao repositório
git config user.name 'desenvolvedor_02'

# Adicionando email de usuário ao repositório
git config user.email 'desenvolvedor_02@proton.me'

# Criar arquivo README.md
touch README.md

# Acessar arquivo e altera-lo
vim README.md {
    Projeto referente ao faturamento de cf'e
}

# Tornando o arquivo 'README.md' rastreável
git add README.md

# Realizando commit do arquivo
git commit -m 'Criando README.md'

# Realizando o push para o bare repositório
git push origin master
```

Ao realizar o `git push origin master` o 'desenvolvedor_02' se deparou com o
seguinte retorno:

```zsh
To /home/salim/exemplos/./projeto_01
 ! [rejected]        master -> master (fetch first)
error: failed to push some refs to '/home/salim/exemplos/./projeto_01'
hint: Updates were rejected because the remote contains work that you do not
hint: have locally. This is usually caused by another repository pushing to
hint: the same ref. If you want to integrate the remote changes, use
hint: 'git pull' before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

O git nos indica realizar `git pull`, mas isso é retornado quando o realizamos.

```
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), 239 bytes | 239.00 KiB/s, done.
From /home/salim/exemplos/./projeto_01
 * branch            master     -> FETCH_HEAD
 * [new branch]      master     -> origin/master
hint: You have divergent branches and need to specify how to reconcile them.
hint: You can do so by running one of the following commands sometime before
hint: your next pull:
hint: 
hint:   git config pull.rebase false  # merge
hint:   git config pull.rebase true   # rebase
hint:   git config pull.ff only       # fast-forward only
hint: 
hint: You can replace "git config" with "git config --global" to set a default
hint: preference for all repositories. You can also pass --rebase, --no-rebase,
hint: or --ff-only on the command line to override the configured default per
hint: invocation.
fatal: Need to specify how to reconcile divergent branches.
```

Agora foi sugerido pelo git três alternativas:

* 1º - git config pull.rebase false:
    O `git config pull.rebase false` indica que não será realizado o rebase nos
    arquivos conflitantes e sim o merge.

* 2º - git config pull.rebase true:
    O `git config pull.rebase true` indica que não será realizado o merge nos
    arquivos conflitantes e sim o rebase.

* 3º - git config pull.ff only:
    O `git config pull.ff only` indica que será utilizado um conceito de fusão
    de branch do git chamado 'fast-forward'.

Com uma breve explicação sobre o que se trata, não utilizaremos o conceito de
'fast-forward' nesse artigo. Restando as duas primeiras opções, o rebase se
torna altamente eficaz nessa situação pois independente da situação, ele monta
um arquivo com as alterações conflitantes.

Com isso utilizaremos o `git config pull.rebase true` e realizaremos novamente
o `git pull`.

```
# Aplicando configurações ao git pull
git config pull.rebase true

# Realizando o pull do bare repositório
git pull origin master
```

Ao realizar o `pull` do repositório é retornado a seguinte informação:

```
From /home/salim/exemplos/./projeto_01
 * branch            master     -> FETCH_HEAD
Auto-merging README.md
CONFLICT (add/add): Merge conflict in README.md
error: could not apply 41353e1... Criando README.md
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply 41353e1... Criando README.md
```

Onde o git informa que não foi possível resolver o conflito, porém montou o
arquivo com todas as informações.

> Nota: Nesse momento estamos dentro de uma branch temporária que é nomeada com
> um hash.

Segue abaixo o conteúdo do arquivo montado automaticamente pelo git.

```
<<<<<<< HEAD
# Este readme é referente ao 'projeto_01'
=======
Projeto referente ao faturamento de cf'e
>>>>>>> 41353e1 (Criando README.md)
```

Nesse momento o conteúdo em conflito estão entre os '<' e '>', sendo divididos
pelos sinais '='.

Nesse contexto podemos intervir manualmente e decidir o que realmente deve
existir, e também sua ordem caso seja de seu interesse.

Resultado da intervenção manual:

```
# Este readme é referente ao 'projeto_01'
Projeto referente ao faturamento de cf'e
```

Com as alterações definidas, prosseguimos:

```
# Tornando o novo arquivo 'README.md' rastreável
git add README.md

# Realizando commit do arquivo
git commit -m 'Resolução de conflito no README.md'

# Confirmar alterações e retornar para o ramo principal
git rebase --continue
```

Com isso o conflito foi resolvido restando apenas realizar o `push` para subir
as alterações.

```
# Realizando o push para o bare repositório
git push origin master
```
