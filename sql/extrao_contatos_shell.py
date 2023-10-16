from tqdm import tqdm

# Instancia tabela
pedido_documento = self.env['pedido.documento']

# Captura ids dos pedido agrupado por participante
pedidos = pedido_documento.read_group(
    [
        ('tipo', 'in', ('venda',)),
        ('data_aprovacao', '>=', '2023-01-01'),
        ('data_aprovacao', '<=', '2023-01-31')
    ],
    fields=['participante_id'],
    groupby=['participante_id']
)


# Mensagem
mensagem = (
    '🔥Ofertas Arretadas Zenir!🔥 Não perca as ofertas com preços incríveis! '
    'Acesse agora mesmo em https://bit.ly/nazenir antes que acabe!'
)

# Envio de mensagens
for pedido in tqdm(pedidos):
    telefone = pedido.trata_telefone_sms()
    nome_cliente = pedido.trata_nome_sms(pedido.participante_id.nome)

    if not telefone:
        continue

    pedido.envia_sms()
