import os
import std/net
import std/nativesockets

type Connection* = object
  socket_location: string
  socket*: Socket

proc connect*(): Connection =
  let socket_location = getEnv("SWAYSOCK")
  if len(socket_location) == 0:
    raise newException(OSError, "SWAYSOCK variable not set")

  let socket = newSocket(AF_UNIX, SOCK_STREAM, IPPROTO_IP)
  socket.connectUnix(socket_location)

  return Connection(
    socket_location: socket_location,
    socket: socket
  )

proc close*(c: Connection) =
  c.socket.close()
