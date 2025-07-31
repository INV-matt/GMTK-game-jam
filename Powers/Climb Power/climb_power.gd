extends Power

@export var ClimbRange = 10
@export var JumpOffSpeed = 50

var isReady = false
var player: Player

func _power_passive(p: Player) :
  player = p
  isReady = true

func _process(delta: float) -> void:
  if not isReady :
    return
    
  if player.velocity.x != 0 :
    return
  
  var dx = Input.get_axis("pl_left", "pl_right")
  
  var last_pos = player.global_position
  var last_vel = player.velocity
  
  player.velocity = Vector2(dx, 0) * ClimbRange
  player.move_and_slide()

  var expected_pos = last_pos + Vector2(dx, 0) * ClimbRange

  # If you asked me how I came up with this I would not be able to explain
  var hangingOnWall = !abs(floor(player.global_position.x) - floor(expected_pos.x)) < ClimbRange
  
  player.global_position = last_pos
  player.velocity = last_vel

  if hangingOnWall :
    if Input.is_action_pressed("pl_down") :
      player.GlobalGravityMult = .25
    elif player.velocity.y > 0 :
      player.GlobalGravityMult = 0
      player.velocity.y = 0
    
      player._jumpCount = 0
      
      if Input.is_action_pressed("pl_jump") :
        player._jump()
        player.GlobalGravityMult = 1
  else :
    player.GlobalGravityMult = 1
