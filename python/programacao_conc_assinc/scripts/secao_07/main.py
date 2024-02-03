from fastapi import FastAPI
from models.produto import Produto


# -----------------------------------------------------------------------------
# Exemplificando a usabilidade do fastapi - Apenas uma introdução
# -----------------------------------------------------------------------------


app = FastAPI()

produtos = [
    Produto(id=1, nome='Playstation 5', preco=5745.55, em_oferta=False),
    Produto(id=2, nome='Nitendo Wii', preco=2654.49, em_oferta=False),
    Produto(id=3, nome='Xbox 360', preco=17855.48, em_oferta=True),
    Produto(id=4, nome='Super Nitendo', preco=234.67, em_oferta=True),
    Produto(id=5, nome='Atari 2600', preco=199.99, em_oferta=True),
]


@app.get('/')
async def index():
    return {'Abel': 'Salim'}


@app.get('/produtos/{id}')
async def busca_produto(id: int):
    for produto in produtos:
        if produto.id == id:
            return [produto]

    return None


@app.put('/produtos/{id}')
async def busca_produto(id: int, produto: Produto):
    for produto_interno in produtos:
        if produto_interno.id == id:
            produto_interno = produto

            return produto_interno

    return None
