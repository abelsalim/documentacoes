from types import SimpleNamespace

retorne: SimpleNamespace = SimpleNamespace()

# Relacionados ao script 'insert_main.py'
retorne.insert_ok = '{} Cadastrado com Sucesso!'
retorne.erro_duplicidade = (
    'Tabela: {} - O(s) parâmetro(s) {} deve(m) ser único(s)!'
)
retorne.erro_tamanho_excedido = (
    'Tabela: {} - O (s) parâmetro(s) {} deve(m) ser único(s)!'
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
    }
)

retorne.tupla_revendedor = (
    {
        'nome': 'Abel Salim',
        'razao_social': 'Abel Salim',
        'cnpj_cpf': '000.000.001-00',
        'celular': '88999997771',
        'email': 'abelsalim@picole.com',
    },
    {
        'nome': 'Edson Lucas',
        'razao_social': 'Edson Lucas',
        'cnpj_cpf': '000.000.002-00',
        'celular': '88988886662',
        'email': 'edsonlucas@picole.com',
    },
    {
        'nome': 'Samuel Levi',
        'razao_social': 'Samuel Levi',
        'cnpj_cpf': '000.000.003-00',
        'celular': '88977775553',
        'email': 'samuellevi@picole.com',
    }
)

retorne.tupla_lote = (
    {
        'tipo_picole_id': '1',
        'quantidade': '79',
    },
    {
        'tipo_picole_id': '2',
        'quantidade': '293',
    },
    {
        'tipo_picole_id': '3',
        'quantidade': '153',
    }
)

retorne.tupla_nota_fical = (
    {
        'revendedor_id': '1',
        'valor': '79.90',
        'numero_serie': 'hahahahahahahahahahahahahahahahahahahahahaha',
        'descricao': '01/02/2024'
    },
    {
        'revendedor_id': '3',
        'valor': '599.99',
        'numero_serie': 'hehehehehehehehehehehehehehehehehehehehehehe',
        'descricao': '01/02/2024'
    },
    {
        'revendedor_id': '1',
        'valor': '1599.70',
        'numero_serie': 'hihihihihihihihihihihihihihihihihihihihihihi',
        'descricao': '03/02/2024'
    },
)

retorne.tupla_picole = (
    {
        'preco': '1',
        'sabor_id': '1',
        'tipo_embalagem_id': '2',
        'tipo_picole_id': '2',
    },
    {
        'revendedor_id': '3',
        'valor': '599.99',
        'numero_serie': 'hehehehehehehehehehehehehehehehehehehehehehe',
        'descricao': '01/02/2024',
    },
    {
        'revendedor_id': '1',
        'valor': '1599.70',
        'numero_serie': 'hihihihihihihihihihihihihihihihihihihihihihi',
        'descricao': '03/02/2024',
    },
)
