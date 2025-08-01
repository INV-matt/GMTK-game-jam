extends Power

var isActive = false
var player: Player

func _power_passive(p: Player) :
  isActive = true
  player = p 
 
func _process(delta: float) -> void:
  if !isActive :
    return
  
  if Input.is_action_just_pressed("pl_attack") :
    player.GlobalGravityDir = -player.GlobalGravityDir
