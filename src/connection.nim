import os
import std/net
import std/nativesockets

type Connection* = object
  socket_location: string
  socket*: Socket

proc connect*(socket_path = ""): Connection =
  var socket_location = socket_path
  if len(socket_location) == 0:
    socket_location = getEnv("SWAYSOCK")
    if len(socket_location) == 0:
      raise newException(OSError, "SWAYSOCK variable not set and socket path not provided")

  let socket = newSocket(AF_UNIX, SOCK_STREAM, IPPROTO_IP)
  socket.connectUnix(socket_location)

  Connection(
    socket_location: socket_location,
    socket: socket
  )

proc close*(c: Connection) =
  c.socket.close()
