from select_main import DataBaseSelect

with DataBaseSelect() as self:
    '''
    # Os seguintes comandos mágicos são fornecidos:

    * %autoreload: Recarregue todos os módulos (exceto aqueles excluídos por
    %aimport) automaticamente agora.

    * %autoreload 0: Desative o recarregamento automático.

    * %autoreload 1: Recarregue todos os módulos importados %aimportsempre antes
    de executar o código Python digitado.

    * %autoreload 2: Recarregue todos os módulos (exceto aqueles excluídos por
    %aimport) sempre antes de executar o código Python digitado.

    * %aimport: Lista os módulos que devem ser importados automaticamente ou
    não.

    * %aimport foo: Importe o módulo 'foo' e marque-o para ser recarregado
    automaticamente para%autoreload 1

    *%aimport -foo: Marque o módulo 'foo' para não ser recarregado
    automaticamente.
    '''

    # Carrega o módulo externo 'autoreload' através de 'load_ext'
    get_ipython().run_line_magic('load_ext', 'autoreload')

    # Recarrega todos os módulos sempre antes de executar o código
    get_ipython().run_line_magic('autoreload', '2')

    # Adiciona self ao 'InteractiveShell' do ipyton
    get_ipython().push({'self': self})

