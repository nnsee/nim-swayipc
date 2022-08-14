import replies
import std/options

proc filterNodesByClass*(parent: t_node, class: string, n = 0): seq[t_node] =
  var i: int
  if parent.window_properties.isSome:
    if parent.window_properties.get.class == class:
      result.add(parent)
      i = i + 1
      if i == n: return
  for node in parent.nodes:
    for child in node.filterNodesByClass(class):
      result.add(child)
      i = i + 1
      if i == n: return
  for node in parent.floating_nodes:
    for child in node.filterNodesByClass(class):
      result.add(child)
      i = i + 1
      if i == n: return
