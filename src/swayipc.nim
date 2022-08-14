import swayipc/connection
export connection.close

proc newSwayConnection*(): Connection =
  connection.connect()
