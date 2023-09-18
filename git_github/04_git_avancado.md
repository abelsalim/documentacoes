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
