select
    empresa.id,
    participante.id,
    participante.nome

from sped_empresa as empresa
    left join sped_participante as participante
        on participante.id = empresa.participante_id;