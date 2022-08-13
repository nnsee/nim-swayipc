import commands, connection

let conn = connection.connect()

let res = conn.run_command("output DP-2 transform 270")

echo res[0].success

conn.close()
