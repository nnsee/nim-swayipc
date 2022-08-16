from replies import t_node, r_get_bar_config, t_input
type
  e_workspace* = object
    change*: string
    current*, old*: t_node

  e_mode* = object
    change*: string
    pango_markup*: bool

  e_window* = object
    change*: string
    container*: t_node

  e_barconfig_update* = r_get_bar_config

  e_binding* = object
    change*, command*, symbol*, input_type*: string
    event_state_mask*: seq[string]
    input_code*: int

  e_shutdown* = object
    change*: string

  e_tick* = object
    first*: bool
    payload*: string

  e_bar_state_update* = object
    id*: string
    visible_by_modifier*: bool

  e_input* = object
    change*: string
    input*: t_input
