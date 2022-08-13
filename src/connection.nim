import os
import std/net
import std/nativesockets
import replies
import std/json
import flatty/binny

from messages import MESSAGE

const MAGIC = "i3-ipc"

type Connection* = object
  socket_location: string
  socket: Socket

type Response = object
  payload_len: int
  message_type: MESSAGE
  payload: string

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

proc send_message(c: Connection, message_type: MESSAGE, payload = "") =
  c.socket.send(MAGIC)
  var payload_len = uint32(len(payload))
  discard c.socket.send(addr payload_len, sizeof(payload_len))
  var msg_typ = uint32(message_type)
  discard c.socket.send(addr msg_typ, sizeof(msg_typ))
  c.socket.send(payload)

proc recv_response(c: Connection): Response =
  let magic = c.socket.recv(len(MAGIC))
  assert magic == MAGIC  # todo: dirty
  let payload_len = c.socket.recv(4).readUint32(0).int
  let message_type = c.socket.recv(4).readUint32(0).int
  let payload = c.socket.recv(payload_len)

  return Response(
    payload_len: payload_len,
    message_type: MESSAGE(message_type),
    payload: payload
  )

proc run_command*(c: Connection, command: string): r_run_command =
  c.send_message(MESSAGE.RUN_COMMAND, command)
  let res = c.recv_response()
  let dataJson = parseJson(res.payload)
  return to(dataJson, r_run_command)
