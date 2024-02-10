from types import SimpleNamespace

retorno = SimpleNamespace()

# Relacionados ao script 'insert_main.py'
retorno.insert_ok = '{} Cadastrado com Sucesso!'
retorno.erro_duplicidade = (
    'O(s) parâmetro(s) {} deve(m) ser único(s)!'
)

retorno.tupla_aditivos = (
    ('Chocolate', 'CCLT'),
    ('Iorgut', 'IGT'),
    ('Milho', 'MLH')
)

retorno.tupla_sabores = (
    ('Chocolate'),
    ('Iorgut'),
    ('Milho')
)

retorno.tupla_t_embalagem = (
    ('Saquinhos Bopp Perola'),
    ('Saquinhos Moreninha BOPP Perolado'),
    ('Folhas de Papel Parafinado')
)

retorno.tupla_t_picole = (
    ('Tradicional'),
    ('Skimo'),
    ('Diet')
)

retorno.tupla_ingredientes = (
    ('Nutela'),
    ('Leite'),
    ('Cacau')
)

retorno.tupla_conservantes = (
    ('Pectina de glicose', 'Espessante e estabilizante'),
    ('Xarope de glicose', 'Evitar a cristalização do sorvete'),
    ('Álcool', 'Retardar a formação de cristais de gelo')
)

