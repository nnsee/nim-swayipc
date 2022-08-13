import commands, connection

let conn = connection.connect()

let res = conn.get_tree

echo res

conn.close()
