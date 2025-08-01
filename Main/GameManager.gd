extends Node
class_name GameManager

@export var UI: CanvasLayer


var _livesUsed = 1

func getLivesUsed() -> int: return _livesUsed


func _ready() -> void:
  SignalBus.player_death.connect(_on_player_death)


func _on_player_death() -> void:
  _livesUsed += 1
  UI.UpdateLives()