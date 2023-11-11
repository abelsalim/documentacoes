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

-------------------------------------------------------------------------------


with dados as (
    select
        empresa.nome as empresa,
        participante.nome as usuario,
        perfil.nome as perfil,
        coalesce(participante.email, '') as email,
        coalesce(participante.celular, '') as celular

    from
        sped_usuario as usuario
        join sped_participante as participante
            on participante.id = usuario.participante_id
        join sped_empresa
            on sped_empresa.id = usuario.empresa_ativa_id
        join sped_participante as empresa
            on empresa.id = sped_empresa.participante_id
        left join sped_usuario_perfil as perfil
            on perfil.id = usuario.perfil_id

    where
        -- tem que ser '>=' pr write date é timestamp e current_date é date
        usuario.write_date >= current_date
        and usuario.active = False
)

select
    dados.empresa as empresa,
    dados.usuario as usuario,
    dados.perfil as perfil,
    dados.email as email,
    dados.celular as celular

from
    dados

order by
    dados.empresa