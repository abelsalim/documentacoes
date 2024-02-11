from config.db_session import DatabaseManager


if __name__ == '__main__':
    db_manager = DatabaseManager()

    # Gerando tabelas
    db_manager.create_tables()
