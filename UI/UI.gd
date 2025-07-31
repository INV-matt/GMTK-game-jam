extends CanvasLayer

@export var MaxLives = 3
@export var t_Lives: TextureRect

const numberSize = 32
var _remainingLives = 3


func _ready() -> void:
  _remainingLives = MaxLives
  SignalBus.player_death.connect(Callable(self, "_on_player_death"))
  UpdateLives()

func UpdateLives() -> void:
  # t_Lives.texture.set("")
  t_Lives.texture.region = Rect2(32 * _remainingLives, 0, 32, 32)

func _on_player_death() -> void:
  _remainingLives -= 1
  UpdateLives()