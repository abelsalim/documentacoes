select
    endereco.estado,
    spe.nome as empresa,
    so.nome as operacao,
    sd.numero,
    sd.serie,
    sd.data_emissao,
    sd.vr_produtos,
    sd.vr_icms_proprio,
    sd.vr_icms_st,
    sd.vr_difal,
    sd.vr_nf,
    
    sum(sd.vr_produtos) over geral as total_geral_vr_produtos,
    sum(sd.vr_icms_proprio) over geral as total_geral_vr_icms_proprio,
    sum(sd.vr_icms_st) over geral as total_geral_vr_icms_st,
    sum(sd.vr_difal) over geral as total_geral_vr_difal,
    sum(sd.vr_nf) over geral as total_geral_vr_nf,

    sum(sd.vr_produtos) over estado as grupo_1_vr_produtos,
    sum(sd.vr_icms_proprio) over estado as grupo_1_vr_icms_proprio,
    sum(sd.vr_icms_st) over estado as grupo_1_vr_icms_st,
    sum(sd.vr_difal) over estado as grupo_1_vr_difal,
    sum(sd.vr_nf) over estado as grupo_1_vr_nf,
    
    sum(sd.vr_produtos) over estado as grupo_2_vr_produtos,
    sum(sd.vr_icms_proprio) over estado as grupo_2_vr_icms_proprio,
    sum(sd.vr_icms_st) over estado as grupo_2_vr_icms_st,
    sum(sd.vr_difal) over estado as grupo_2_vr_difal,
    sum(sd.vr_nf) over estado as grupo_2_vr_nf

from
    sped_documento sd
    join sped_participante sp on sp.id = sd.participante_id
    
    join sped_empresa se on se.id = sd.empresa_id
    join sped_participante spe on spe.id = se.participante_id
    
    join sped_operacao so on so.id = sd.operacao_id
    join sped_endereco as endereco on endereco.id = sd.endereco_entrega_id
    
where
    sd.situacao_nfe = 'autorizada'
    --
    -- Venda normal - ID 5
    -- Venda para entrega futura - ID 2
    -- Venda no atacado - ID 106
    -- Venda de ativo - ID 95
    -- Venda NFC-e - ID 1
    -- Venda CF-e - ID 4
    --
    and sd.operacao_id in (5, 2, 106, 95, 1, 4)
    and sd.data_apuracao between '2023-12-01' and '2023-12-31'
    and endereco.estado != 'CE'
    and sd.empresa_id = 366

window
    geral as (),
    estado as (partition by sp.estado order by sp.estado),
    loja as (partition by sp.estado, spe.nome order by sp.estado, spe.nome)
    
order by
    sp.estado,
    spe.nome,
    sd.data_emissao,
    sd.serie,
    sd.numero
    