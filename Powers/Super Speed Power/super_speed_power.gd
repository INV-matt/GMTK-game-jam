extends Power

var p: Player

@export var Multiplier = 1.25

func _power_passive(player: Player) :
  p = player
  
  p.Speed *= Multiplier
  p.Acceleration *= Multiplier

func _exit_tree() -> void:
  p.Speed /= Multiplier
  p.Acceleration /= Multiplier
