from tqdm import tqdm


SQL  = '''
    with dados as (
        select
            usuario.id as usuario_id

        from
            sped_usuario as usuario
            left join sped_usuario_sessao as sessao
                on sessao.usuario_id = usuario.id

        where
            -- captura apenas sessões de até 40 dias
            sessao.data >= current_date - interval '40 days'

        group by
            usuario.id
    )

    select
        usuario.id as usuario_id

    from
        sped_usuario as usuario
        left join dados
            on dados.usuario_id = usuario.id

    where
        dados.usuario_id is null
        -- não inclui perfil de: Diretores, Vendedor Celular-Informática,
        -- Vendedores, Vendedores Cama-Mesa, Vendedor ZEFLEX
        and usuario.perfil_id not in (64, 57, 1, 54, 61)
        -- apenas usuários ativos
        and usuario.active = True

    limit 10
'''

self.env.cr.execute(SQL)
dados = self.env.cr.fetchall()

# busca usuários
usuarios = self.env['sped.usuario'].search([('id', 'in', dados)])

for usuario in tqdm(usuarios):
    # Atualiza banco
    usuario.active = False
    usuario.flush()
    self.env.cr.commit()

    # não faz cache
    usuario.invalidate_cache()
