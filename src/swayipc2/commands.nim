import connection
import messages
import events
import replies
import std/[asyncdispatch, asyncnet, json, net]

const MAGIC = "i3-ipc"

type Response = object
  payload_len: int
  message_type: MESSAGE
  payload: string

proc read_as_uint32(b: string): int {.inline.} =
  var t: uint32
  copyMem(t.addr, b[0].unsafeAddr, 4)
  t.int

proc send_message(c: Connection|AsyncConnection, message_type: MESSAGE, payload = "") {.multisync.} =
  await c.socket.send(MAGIC)
  var payload_len = uint32(len(payload))
  var msg_typ = uint32(message_type)
  when c is Connection:
    discard c.socket.send(addr payload_len, sizeof(payload_len))
    discard c.socket.send(addr msg_typ, sizeof(msg_typ))
  else:
    await c.socket.send(addr payload_len, sizeof(payload_len))
    await c.socket.send(addr msg_typ, sizeof(msg_typ))
  await c.socket.send(payload)

proc recv_response(c: Connection|AsyncConnection): Future[Response] {.multisync.} =
  let magic = await c.socket.recv(len(MAGIC))
  assert magic == MAGIC  # todo: dirty
  let payload_len = (await c.socket.recv(4)).read_as_uint32
  let message_type = MESSAGE((await c.socket.recv(4)).read_as_uint32)
  let payload = await c.socket.recv(payload_len)

  return Response(
      payload_len: payload_len,
      message_type: message_type,
      payload: payload
    )

proc processEvent*(r: Response): e_workspace | e_mode | e_window | e_barconfig_update | e_binding |
    e_shutdown | e_tick | e_bar_state_update | e_input =
  let ev = case EVENT(r.message_type):
    of WORKSPACE:
      e_workspace
    of MODE:
      e_mode
    of WINDOW:
      e_window
    of BARCONFIG_UPDATE:
      e_barconfig_update
    of BINDING:
      e_binding
    of SHUTDOWN:
      e_shutdown
    of TICK:
      e_tick
    of BAR_STATE_UPDATE:
      e_bar_state_update
    of INPUT:
      e_input
  let res = parseJson(r.payload)
  return to(res, ev)

proc send_recv(c: Connection|AsyncConnection, m: MESSAGE, payload = ""): Future[JsonNode] {.multisync.} =
  await c.send_message(m, payload)
  let res = parseJson((await c.recv_response()).payload)
  return res

proc run_command*(c: Connection|AsyncConnection, command: string): Future[r_run_command] {.multisync.} =
  return to(await c.send_recv(MESSAGE.RUN_COMMAND, command), r_run_command)

proc get_workspaces*(c: Connection|AsyncConnection): Future[r_get_workspaces] {.multisync.} =
  return to(await c.send_recv(MESSAGE.GET_WORKSPACES), r_get_workspaces)

proc subscribe*(c: Connection|AsyncConnection, events: seq[EVENT]): Future[r_subscribe] {.multisync.} =
  return to(await c.send_recv(MESSAGE.SUBSCRIBE, $(%*events)), r_subscribe)

proc get_outputs*(c: Connection|AsyncConnection): Future[r_get_outputs] {.multisync.} =
  return to(await c.send_recv(MESSAGE.GET_OUTPUTS), r_get_outputs)

proc get_tree*(c: Connection|AsyncConnection): Future[r_get_tree] {.multisync.} =
  return to(await c.send_recv(MESSAGE.GET_TREE), r_get_tree)

proc get_marks*(c: Connection|AsyncConnection): Future[r_get_marks] {.multisync.} =
  return to(await c.send_recv(MESSAGE.GET_MARKS), r_get_marks)

proc get_bar_config*(c: Connection|AsyncConnection): Future[r_get_bar_config_no_payload] {.multisync.} =
  return to(await c.send_recv(MESSAGE.GET_BAR_CONFIG), r_get_bar_config_no_payload)

proc get_bar_config*(c: Connection|AsyncConnection, id: string): Future[r_get_bar_config] {.multisync.} =
  return to(await c.send_recv(MESSAGE.GET_BAR_CONFIG, id), r_get_bar_config)

proc get_version*(c: Connection|AsyncConnection): Future[r_get_version] {.multisync.} =
  return to(await c.send_recv(MESSAGE.GET_VERSION), r_get_version)

proc get_binding_modes*(c: Connection|AsyncConnection): Future[r_get_binding_modes] {.multisync.} =
  return to(await c.send_recv(MESSAGE.GET_BINDING_MODES), r_get_binding_modes)

proc get_config*(c: Connection|AsyncConnection): Future[r_get_config] {.multisync.} =
  return to(await c.send_recv(MESSAGE.GET_CONFIG), r_get_config)

proc send_tick*(c: Connection|AsyncConnection, payload = ""): Future[r_send_tick] {.multisync.} =
  return to(await c.send_recv(MESSAGE.SEND_TICK, payload), r_send_tick)

proc get_binding_state*(c: Connection|AsyncConnection): Future[r_get_binding_state] {.multisync.} =
  return to(await c.send_recv(MESSAGE.GET_BINDING_STATE), r_get_binding_state)

proc get_inputs*(c: Connection|AsyncConnection): Future[r_get_inputs] {.multisync.} =
  return to(await c.send_recv(MESSAGE.GET_INPUTS), r_get_inputs)

proc get_seats*(c: Connection|AsyncConnection): Future[r_get_seats] {.multisync.} =
  return to(await c.send_recv(MESSAGE.GET_SEATS), r_get_seats)
