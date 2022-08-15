import swayipc2/connection
export connection.close

proc newSwayConnection*(): Connection =
  connection.connect()
