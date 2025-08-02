extends Power

var active = false
var player: Player

func _power_passive(p: Player):
  active = true
  player = p

func _process(delta: float) -> void:
  if !active:
    return
  
  if player.GlobalGravityMult == 1:
    player.GlobalGravityMult = .5

func _exit_tree():
  Globals.getPlayer().GlobalGravityMult = 1
