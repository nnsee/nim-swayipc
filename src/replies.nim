import std/options

type
  # objects that can be found in replies
  t_command_status = object
    success*: bool
    parse_error*: Option[bool]
    error*: Option[string]

  t_workspace = object
    num*: int
    name*, output*: string
    visible*, focused*, urgent*: bool
    rect*: t_rect

  t_rect = object
    x*, y*, width*, height*: int

  t_output = object
    name*, make*, model*, serial*, subpixel_hinting*, transform*, current_workspace*: string
    active*, dpms*, primary*: bool
    modes*: seq[t_mode]

  t_mode = object
    width*, height*, refresh*: int

  t_node = object
    id*, current_border_width*, fullscreen_mode*, pid*, window*: int
    name*, `type`*, border*, layout*, orientation*, representation*, app_id*, shell*: string
    percent*: float
    rect*, window_rect*, deco_rect*, geometry*: t_rect
    urgent*, sticky*, focused*, visible*, inhibit_idle*: bool
    marks*: seq[string]
    focus*: seq[int]
    nodes*, floating_nodes*: seq[t_node]
    idle_inhibitors*: t_idle_inhibitors
    window_properties*: t_window_properties

  t_idle_inhibitors = object
    application*, user*: string

  t_window_properties = object
    class*, instance*, title*, transient_for*: string

  t_input = object
    identifier*, name*, `type`*, xkb_active_layout_name*: string
    vendor*, product*, xkb_active_layout_index*: int
    xkb_layout_names*: seq[string]
    scroll_factor*: float
    libinput*: t_libinput

  t_seat = object
    name*: string
    capabilities*, focus*: int
    devices*: r_get_inputs

  t_colors = object
    background*, statusline*, separator*, focused_background*, focused_statusline*, focused_separator*, focused_workspace_text*,
      focused_workspace_bg*, focused_workspace_border*, active_workspace_text*, active_workspace_bg*, active_workspace_border*,
      inactive_workspace_text*, inactive_workspace_bg*, inactive_workspace_border*, urgent_workspace_text*, urgent_workspace_bg*,
      urgent_workspace_border*, binding_mode_text*, binding_mode_bg*, binding_mode_border*: string

  t_gaps = object
    top*, right*, bottom*, left*: int

  t_libinput = object
    send_events*, tap*, tap_button_map*, tap_drag*, tap_drag_lock*, accel_profile*, natural_scroll*, left_handed*, click_method*,
      middle_emulation*, scroll_method*, dwt*: string
    accel_speed*: cdouble
    scroll_button*: int
    calibration_matrix*: seq[float]

  # replies themselves
  r_run_command* = seq[t_command_status]

  r_get_workspaces* = seq[t_workspace]

  r_subscribe* = object
    success*: bool

  r_get_outputs* = seq[t_output]

  r_get_tree* = t_node

  r_get_marks* = seq[string]

  r_get_bar_config_no_payload* = seq[string]

  r_get_bar_config* = object
    id*, mode*, position*, status_command*, font*: string
    workspace_buttons*, binding_mode_indicator*, verbose*: bool
    workspace_min_width*, bar_height*, status_padding*, status_edge_padding*: int
    colors*: t_colors
    gaps*: t_gaps

  r_get_version* = object
    major*, minor*, patch*: int
    human_readable*, loaded_config_file_name*: string

  r_get_binding_modes* = seq[string]

  r_get_config* = object
    config*: string

  r_send_tick* = object
    success*: bool

  r_sync* = object
    success*: bool

  r_get_binding_state* = object
    name*: string

  r_get_inputs* = seq[t_input]

  r_get_seats* = seq[t_seat]

  # event payloads
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
