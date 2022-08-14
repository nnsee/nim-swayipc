import replies
import std/options

template add_node_and_check(node: t_node) =
  result.add(node)
  i = i + 1
  if i == n: return

template loop_and_add(f: proc, nodes: seq[t_node], id: string) =
  for node in nodes:
    for child in node.f(id, n - i):
      add_node_and_check(child)

proc filterNodesByClass*(parent: t_node, class: string, n = 0): seq[t_node] =
  var i: int
  if parent.window_properties.isSome:
    if parent.window_properties.get.class == class:
      add_node_and_check(parent)
  loop_and_add(filterNodesByClass, parent.nodes, class)
  loop_and_add(filterNodesByClass, parent.floating_nodes, class)

proc filterNodesByAppID*(parent: t_node, app_id: string, n = 0): seq[t_node] =
  var i: int
  if parent.app_id.isSome:
    if parent.app_id.get == app_id:
      add_node_and_check(parent)
  loop_and_add(filterNodesByAppID, parent.nodes, app_id)
  loop_and_add(filterNodesByAppID, parent.floating_nodes, app_id)
