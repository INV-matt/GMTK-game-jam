extends Power

var p: Player

@export var Multiplier = 2

func _power_passive(player: Player):
  p = player
  
  p.SetSuperSpeedMultiplier(Multiplier)

var slowZoneScene = preload("res://Powers/Super Speed Power/slow_zone.tscn")

func _power_death(player: Player):
  var zone: Area2D = slowZoneScene.instantiate()
  
  zone.global_position = player.global_position
  zone.position.y += 14
  
  get_tree().get_root().call_deferred("add_child", zone)

func _exit_tree() -> void:
  Globals.getPlayer().SetSuperSpeedMultiplier(1)
