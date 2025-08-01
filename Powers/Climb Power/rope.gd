extends Area2D
  
@export var ClimbSpeed = 5

var canPlayerClimb = false
var player: Player

func _ready() -> void:
  connect("body_entered", func(x): player = x; canPlayerClimb = true)
  connect("body_exited", func(x): player = x; canPlayerClimb = false)

func _process(delta: float) -> void:
  if not player :
    return
    
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
