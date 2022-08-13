import commands, connection

let conn = connection.connect()

echo conn.get_tree

echo conn.get_inputs

conn.close()
