from tqdm import tqdm


# ID's dos departamentos
ID_DPT_COBRANCA = 25
ID_DPT_DIRETORIA = 49
ID_DPT_GERENTE_ATENDIMENTO = 36

# ID's dos perfis
IDS_PERFIS_COBRANCA = [37, 32]
IDS_PERFIS_DIRETORIA = [64]
IDS_PERFIS_GERENTE_ATENDIMENTO = [30, 78, 68]

# Listas para o zip
DEPARTAMENTOS = [
    ID_DPT_COBRANCA,
    ID_DPT_DIRETORIA,
    ID_DPT_GERENTE_ATENDIMENTO
]

PERFIS = [
    IDS_PERFIS_COBRANCA,
    IDS_PERFIS_DIRETORIA,
    IDS_PERFIS_GERENTE_ATENDIMENTO
]


def executa():
    for perfil_id, departamento_id in zip(PERFIS, DEPARTAMENTOS):

        # Coleta usuários
        usuarios = self.env['sped.usuario'].search(
            [
                ('perfil_id', 'in', perfil_id)
            ]
        )

        departamento = self.env['sped.usuario.departamento'].browse(departamento_id)

        # Itera nos usuários
        for usuario in tqdm(usuarios):

            print(usuario.departamento_ids.ids, usuario.nome)

            # Atribui e grava no banco
            usuario.departamento_ids |= departamento
            usuario.flush()
            self.env.cr.commit()

            print(usuario.departamento_ids.ids, usuario.nome)

            usuario.invalidate_cache()

        departamento.invalidate_cache()


executa()
