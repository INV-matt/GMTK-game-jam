extends Node

@export var player: Player

func _ready() -> void:
  player = get_node("../Main").get_node("%Player") as Player