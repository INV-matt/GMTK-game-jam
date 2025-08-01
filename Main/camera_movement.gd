extends Camera2D

@export var ScoutSpeed = 300.0
@export var ScoutZoomMult = 0.8
# @export var ScoutCameraSpeed = 5

var _isScouting = false

func _ready() -> void:
  SignalBus.connect("scout_enter", Callable(self, "_on_scout_enter"))
  SignalBus.connect("scout_exit", Callable(self, "_on_scout_exit"))

@onready var parallax = $"../../parallax"

func _process(delta: float) -> void:
  if _isScouting:
    var xdir = Input.get_axis("pl_left", "pl_right")
    var ydir = Input.get_axis("pl_up", "pl_down")

    position += ScoutSpeed * delta * Vector2(xdir, ydir) # * ScoutCameraSpeed

  var viewport_size = get_viewport_rect().size

  #.offset.y = (-viewport_size.y/3 + global_position.y)*3
  parallax.offset.y = get_screen_center_position().y*3 - viewport_size.y

func _on_scout_enter() -> void:
  print("scout entered")
  zoom *= ScoutZoomMult
  _isScouting = true
  return

func _on_scout_exit() -> void:
  print("scout exited")
  zoom /= ScoutZoomMult
  position = Vector2(0, 0)
  _isScouting = false
  return
