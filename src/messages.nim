type
  MESSAGE* {.pure.} = enum
    RUN_COMMAND
    GET_WORKSPACES
    SUBSCRIBE
    GET_OUTPUTS
    GET_TREE
    GET_MARKS
    GET_BAR_CONFIG
    GET_VERSION
    GET_BINDING_MODES
    GET_CONFIG
    SEND_TICK
    SYNC
    GET_BINDING_STATE
    GET_INPUTS = 100
    GET_SEATS

  EVENT* {.pure.} = enum
    WORKSPACE = 0x80000000
    MODE = 0x80000002
    WINDOW
    BARCONFIG_UPDATE
    BINDING
    SHUTDOWN
    TICK
    BAR_STATE_UPDATE = 0x80000014
    INPUT
