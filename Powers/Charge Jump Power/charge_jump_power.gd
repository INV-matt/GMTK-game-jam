extends Power

@export var MaxVelocityMult = 2

var isActive = false
var player: Player
var originalvelocity = 0
var currentVelocity = 0

func _power_passive(p: Player) :
  isActive = true
  player = p
  
  originalvelocity = player._jumpVelocity
  
  player._jumpVelocity = 0

func _process(delta: float) -> void:
  if !isActive :
    return
    
  player._jumpVelocity = currentVelocity
  player.scale.y = 1 - currentVelocity / (originalvelocity * MaxVelocityMult) * .5
  
  if Input.is_action_pressed("pl_jump") :
    if player.is_on_floor() :
      currentVelocity += originalvelocity / 60
      if currentVelocity >= originalvelocity * MaxVelocityMult :
        currentVelocity = originalvelocity * MaxVelocityMult
  elif currentVelocity > originalvelocity / 60 :
    player._jump()
    currentVelocity = 0
  
  print(currentVelocity)

func _exit_tree() -> void:
  player.scale.y = 1
  player._jumpVelocity = originalvelocity
