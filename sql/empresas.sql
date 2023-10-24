select
    empresa.id as empresa,
    participante.id as participante,
    participante.nome as nome

from sped_empresa as empresa
    left join sped_participante as participante
        on participante.id = empresa.participante_id;