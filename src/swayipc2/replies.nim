import std/options

type
  # objects that can be found in replies
  t_command_status* = object
    success*: bool
    parse_error*: Option[bool]
    error*: Option[string]

  t_workspace* = object
    num*: int
    name*, output*: string
    visible*, focused*, urgent*: bool
    rect*: t_rect

  t_rect = object
    x*, y*, width*, height*: int

  t_output* = object
    name*, make*, model*, serial*, subpixel_hinting*, transform*, current_workspace*: string
    active*, dpms*, primary*: bool
    modes*: seq[t_mode]

  t_mode* = object
    width*, height*, refresh*: int

  t_node* = object
    id*, current_border_width*: int
    name*, `type`*, border*, layout*, orientation*: string
    representation*, app_id*, shell*: Option[string]
    fullscreen_mode*, pid*, window*: Option[int]
    visible*, inhibit_idle*: Option[bool]
    percent*: Option[float]
    rect*, window_rect*, deco_rect*, geometry*: t_rect
    urgent*, sticky*, focused*: bool
    marks*: seq[string]
    focus*: seq[int]
    nodes*, floating_nodes*: seq[t_node]
    idle_inhibitors*: Option[t_idle_inhibitors]
    window_properties*: Option[t_window_properties]

  t_idle_inhibitors* = object
    application*, user*: string

  t_window_properties* = object
    class*, instance*, title*: string
    transient_for*: Option[int]

  t_input* = object
    identifier*, name*, `type`*: string
    xkb_active_layout_name*: Option[string]
    vendor*, product*: int
    xkb_active_layout_index*: Option[int]
    xkb_layout_names*: Option[seq[string]]
    scroll_factor*: Option[float]
    libinput*: Option[t_libinput]

  t_seat* = object
    name*: string
    capabilities*, focus*: int
    devices*: r_get_inputs

  t_colors* = object
    background*, statusline*, separator*, focused_background*, focused_statusline*, focused_separator*, focused_workspace_text*,
      focused_workspace_bg*, focused_workspace_border*, active_workspace_text*, active_workspace_bg*, active_workspace_border*,
      inactive_workspace_text*, inactive_workspace_bg*, inactive_workspace_border*, urgent_workspace_text*, urgent_workspace_bg*,
      urgent_workspace_border*, binding_mode_text*, binding_mode_bg*, binding_mode_border*: string

  t_gaps* = object
    top*, right*, bottom*, left*: int

  t_libinput* = object
    send_events*, tap*, tap_button_map*, tap_drag*, tap_drag_lock*, accel_profile*, natural_scroll*, left_handed*, click_method*,
      middle_emulation*, scroll_method*, dwt*: Option[string]
    accel_speed*: Option[cdouble]
    scroll_button*: Option[int]
    calibration_matrix*: Option[seq[float]]

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
