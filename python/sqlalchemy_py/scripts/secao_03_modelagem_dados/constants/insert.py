from types import SimpleNamespace

retorne = SimpleNamespace()

# Relacionados ao script 'insert_main.py'
retorne.insert_ok = '{} Cadastrado com Sucesso!'
retorne.erro_duplicidade = (
    'Tabela: {} - O(s) parâmetro(s) {} deve(m) ser único(s)!'
)

retorne.tupla_aditivos = (
    {'nome': 'Chocolate', 'formula_quimica': 'CCLT'},
    {'nome': 'Iorgut', 'formula_quimica': 'IGT'},
    {'nome': 'Milho', 'formula_quimica': 'MLH'},
)

retorne.tupla_sabores = (
    {'nome': 'Chocolate'},
    {'nome': 'Iorgut'},
    {'nome': 'Milho'}
)

retorne.tupla_t_embalagem = (
    {'nome': 'Saquinhos Bopp Perola'},
    {'nome': 'Saquinhos Moreninha BOPP Perolado'},
    {'nome': 'Folhas de Papel Parafinado'}
)

retorne.tupla_t_picole = (
    {'nome': 'Tradicional'},
    {'nome': 'Skimo'},
    {'nome': 'Diet'}
)

retorne.tupla_ingredientes = (
    {'nome': 'Nutela'},
    {'nome': 'Leite'},
    {'nome': 'Cacau'}
)

retorne.tupla_conservantes = (
    {
        'nome': 'Pectina de glicose',
        'descricao': 'Espessante e estabilizante'
    },
    {
        'nome': 'Xarope de glicose',
        'descricao': 'Evitar a cristalização do sorvete'
    },
    {
        'nome': 'Álcool',
        'descricao': 'Retardar a formação de cristais de gelo'
    },
)

