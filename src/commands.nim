from connection import Connection
from messages import MESSAGE
import replies
import std/json
import std/net
import flatty/binny

const MAGIC = "i3-ipc"

type Response = object
  payload_len: int
  message_type: MESSAGE
  payload: string

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
  let message_type = MESSAGE(c.socket.recv(4).readUint32(0).int)
  let payload = c.socket.recv(payload_len)

  return Response(
    payload_len: payload_len,
    message_type: message_type,
    payload: payload
  )

proc send_recv(c: Connection, m: MESSAGE, payload = ""): JsonNode =
  c.send_message(m, payload)
  let res = c.recv_response()
  result = parseJson(res.payload)

proc run_command*(c: Connection, command: string): r_run_command =
  return to(c.send_recv(MESSAGE.RUN_COMMAND, command), r_run_command)

proc get_workspaces*(c: Connection): r_get_workspaces =
  return to(c.send_recv(MESSAGE.GET_WORKSPACES), r_get_workspaces)

# todo: implement subscribe

proc get_outputs*(c: Connection): r_get_outputs =
  return to(c.send_recv(MESSAGE.GET_OUTPUTS), r_get_outputs)

proc get_tree*(c: Connection): r_get_tree =
  return to(c.send_recv(MESSAGE.GET_TREE), r_get_tree)

proc get_marks*(c: Connection): r_get_marks =
  return to(c.send_recv(MESSAGE.GET_MARKS), r_get_marks)

proc get_bar_config*(c: Connection): r_get_bar_config_no_payload =
  return to(c.send_recv(MESSAGE.GET_BAR_CONFIG), r_get_bar_config_no_payload)

proc get_bar_config*(c: Connection, id: string): r_get_bar_config =
  return to(c.send_recv(MESSAGE.GET_BAR_CONFIG, id), r_get_bar_config)

proc get_version*(c: Connection): r_get_version =
  return to(c.send_recv(MESSAGE.GET_VERSION), r_get_version)

proc get_binding_modes*(c: Connection): r_get_binding_modes =
  return to(c.send_recv(MESSAGE.GET_BINDING_MODES), r_get_binding_modes)

proc get_config*(c: Connection): r_get_config =
  return to(c.send_recv(MESSAGE.GET_CONFIG), r_get_config)

proc send_tick*(c: Connection, payload = ""): r_send_tick =
  return to(c.send_recv(MESSAGE.SEND_TICK, payload), r_send_tick)

proc get_binding_state*(c: Connection): r_get_binding_state =
  return to(c.send_recv(MESSAGE.GET_BINDING_STATE), r_get_binding_state)

proc get_inputs*(c: Connection): r_get_inputs =
  return to(c.send_recv(MESSAGE.GET_INPUTS), r_get_inputs)

proc get_seats*(c: Connection): r_get_seats =
  return to(c.send_recv(MESSAGE.GET_SEATS), r_get_seats)
