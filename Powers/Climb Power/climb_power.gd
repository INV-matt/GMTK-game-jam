extends Power

@export var ClimbRange = 10
@export var JumpOffSpeed = 50

var isReady = false
var player: Player

func _power_passive(p: Player) :
  player = p
  isReady = true
  
@export var RopeHeight = 200
@export var ClimbSpeed = 5

var canPlayerClimb = false

func _power_death(p: Player) :
  var area = Area2D.new()
  var shape = CollisionShape2D.new()
  
  shape.shape = RectangleShape2D.new()
  (shape.shape as RectangleShape2D).size = Vector2(20, RopeHeight)
  
  area.add_child(shape)
  area.global_position = p.global_position
  area.position.y -= RopeHeight/2
  area.collision_layer = 0
  area.collision_mask = 2
  area.connect("body_entered", func(x): canPlayerClimb = true)
  area.connect("body_exited", func(x): canPlayerClimb = false)
  
  get_tree().get_root().add_child(area)

func _process(delta: float) -> void:
  if canPlayerClimb :
    player._setAnimation("idle")
    player.GlobalGravityMult = 0
    player.velocity.y = 0
    if Input.is_action_pressed("pl_up") :
      player.position.y -= ClimbSpeed
    if Input.is_action_pressed("pl_down") :
      player.position.y += ClimbSpeed
  else :
    player.GlobalGravityMult = 1
  
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
