extends Area2D
  
@export var ClimbSpeed = 5

var canPlayerClimb = false
var player: Player
var attachHeight = 0

func _ready() -> void:
  connect("body_entered", func(x: Player): player = x; attachHeight = x.global_position.y; canPlayerClimb = true)
  connect("body_exited", func(x: Player): player = x; canPlayerClimb = false)

func _process(delta: float) -> void:
  if not player :
    return
    
  player._isClimbing = canPlayerClimb
    
  if canPlayerClimb :
    player._setAnimation("climb")
    player.GlobalGravityMult = 0
    player.velocity.y = 0
    
    var dy = Input.get_axis("pl_up", "pl_down")
    attachHeight += ClimbSpeed * dy
    
    for i in player.get_children() :
      if i is AnimatedSprite2D :
        (i as AnimatedSprite2D).speed_scale = dy
        break
    
    player.global_position.y = attachHeight
  else :
    player.GlobalGravityMult = 1
