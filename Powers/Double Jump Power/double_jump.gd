extends Power

var p: Player

# Maybe this should be just "= 2" instead of "+ 1" idk
func _power_passive(player: Player):
  player.IncreaseMaxJumps(1)
  p = player

var trampolineScene = preload("res://Powers/Double Jump Power/trampoline.tscn")

func _power_death(p: Player):
  var area = trampolineScene.instantiate()
  area.global_position = p.global_position
  
  get_tree().get_root().call_deferred("add_child", area)

func _exit_tree() -> void:
  Globals.getPlayer().ResetMaxJumps()
