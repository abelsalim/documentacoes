from types import SimpleNamespace


db_session = SimpleNamespace()

# Relacionadas ao arquivo 'db_session.py'
db_session.arquivo_db = 'db/picoles.sqlite'
db_session.string_connection_sqlite = f'sqlite:///{db_session.arquivo_db}'

db_session.user = 'salim'
db_session.password = 'hahaha'
db_session.database_name = 'my_project'

db_session.string_connection_postgresql = (
    f'postgresql://{db_session.user}:{db_session.password}@localhost:5432'
    f'/{db_session.database_name}'
)
