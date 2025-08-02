extends Power

@export var ClimbRange = 10
@export var JumpOffSpeed = 50

var isReady = false
var player: Player

func _power_passive(p: Player):
  player = p
  isReady = true

var canPlayerClimb = false
var ropeScene = preload("res://Powers/Climb Power/rope.tscn")

func _power_death(p: Player):
  var rope = ropeScene.instantiate()
  rope.global_position = p.global_position
 
  get_tree().get_root().call_deferred("add_child", rope)

func _process(delta: float) -> void:
  if not isReady:
    return
    
  if player.velocity.x != 0:
    return
  
  var dx = Input.get_axis("pl_left", "pl_right")
  
  var last_pos = player.global_position
  var last_vel = player.velocity
  
  player.velocity = Vector2(dx, 0) * ClimbRange
  player.move_and_slide()

  var expected_pos = last_pos + Vector2(dx, 0) * ClimbRange

  # If you asked me how I came up with this I would not be able to explain
  # var hangingOnWall = !abs(floor(player.global_position.x) - floor(expected_pos.x)) < ClimbRange
  var hangingOnWall = player.is_on_wall_only() && player._direction != 0
  
  player.global_position = last_pos
  player.velocity = last_vel

  if hangingOnWall:
    if Input.is_action_pressed("pl_down"):
      player.GlobalGravityMult = .25
    elif player.velocity.y > 0:
      player.GlobalGravityMult = 0
      player.velocity.y = 0
    
      player._jumpCount = 0
      
      if Input.is_action_pressed("pl_jump"):
        player._jump()
        player.GlobalGravityMult = 1
  else:
    player.GlobalGravityMult = 1
