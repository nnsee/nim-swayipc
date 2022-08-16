import os
import std/[asyncnet, asyncdispatch, nativesockets, net]

type Connection* = object
  socket_location: string
  socket*: Socket

type AsyncConnection* = object
  socket_location: string
  socket*: AsyncSocket

proc get_sock_path(socket_path = ""): string {.inline.} =
  result = socket_path
  if len(result) == 0:
    result = getEnv("SWAYSOCK")
    if len(result) == 0:
      raise newException(OSError, "SWAYSOCK variable not set and socket path not provided")

proc connect*(socket_path = ""): Connection =
  let socket_location = socket_path.get_sock_path

  let socket = newSocket(AF_UNIX, SOCK_STREAM, IPPROTO_IP)
  socket.connectUnix(socket_location)

  Connection(
    socket_location: socket_location,
    socket: socket
  )

proc connect_async*(socket_path = ""): Future[AsyncConnection] {.async.} =
  let socket_location = socket_path.get_sock_path

  let socket = newAsyncSocket(AF_UNIX, SOCK_STREAM, IPPROTO_IP)
  await socket.connectUnix(socket_location)

  return AsyncConnection(
    socket_location: socket_location,
    socket: socket
  )

proc close*(c: Connection or AsyncConnection) =
  c.socket.close()
