extends Power

var p: Player

@export var Multiplier = 1.25

func _power_passive(player: Player) :
  p = player
  
  p.Speed *= Multiplier
  p.Acceleration *= Multiplier

var slowZoneScene = preload("res://Powers/Dash Power/slow_zone.tscn")

func _power_death(player: Player) :
  var zone: Area2D = slowZoneScene.instantiate()
  
  zone.global_position = player.global_position
  
  get_tree().get_root().call_deferred("add_child", zone)

func _exit_tree() -> void:
  p.Speed /= Multiplier
  p.Acceleration /= Multiplier
