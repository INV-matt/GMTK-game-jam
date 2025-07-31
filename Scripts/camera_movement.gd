extends Camera2D

@export var ScoutSpeed = 300.0
@export var ScoutZoomMult = 0.8


var _isScouting = false


func _ready() -> void:
  SignalBus.connect("scout_enter", Callable(self, "_on_scout_enter"))
  SignalBus.connect("scout_exit", Callable(self, "_on_scout_exit"))

func _process(delta: float) -> void:
  if _isScouting:
    var xdir = Input.get_axis("pl_left", "pl_right")
    var ydir = Input.get_axis("pl_up", "pl_down")

    position += ScoutSpeed * delta * Vector2(xdir, ydir)


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