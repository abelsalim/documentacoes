from sqlalchemy_py.scripts.secao_03_modelagem_dados.config.db_session import (
    DatabaseManager
)


if __name__ == '__main__':
    db_manager = DatabaseManager()

    # Gerando tabelas
    db_manager.create_tables()
