from types import SimpleNamespace


session_db: SimpleNamespace = SimpleNamespace()

# Relacionadas ao arquivo 'session_db.py'
session_db.arquivo_db = 'db/picoles.sqlite'
session_db.string_connection_sqlite = f'sqlite:///{session_db.arquivo_db}'

session_db.user = 'salim'
session_db.password = 'hahaha'
session_db.database_name = 'my_project'

session_db.string_connection_postgresql = (
    f'postgresql://{session_db.user}:{session_db.password}@localhost:5432'
    f'/{session_db.database_name}'
)
