extends Power

var player: Player

func _power_passive(p: Player) :
  p.scale /= 2
  player = p

func _exit_tree() -> void:
  player.scale *= 2
