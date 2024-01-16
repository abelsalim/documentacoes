select
    empresa.id as empresa,
    participante.id as participante,
    participante.nome as nome,
    regional.nome as regional

from sped_empresa as empresa
    left join sped_participante as participante
        on participante.id = empresa.participante_id
    join sped_empresa_grupos as regional
        on regional.id = empresa.grupo_regional_id

order by
    participante.nome