extends Power

@export var Speed = 500
@export var Length = 5

var isReady = false
var player: Player
var canDash = true

var length = 0
var dir = Vector2.ZERO

func _power_passive(p: Player):
  isReady = true
  player = p

func _process(delta: float) -> void:
  if not isReady:
    return
    
  if length > 0:
    length -= 1
    player.velocity = dir * Speed
    player.move_and_slide()
    return
  else:
    player.movementLocked = false
  
  if canDash and Input.is_action_pressed("pl_dash"):
    var dx = Input.get_axis("pl_left", "pl_right")
    var dy = Input.get_axis("pl_up", "pl_down")
    
    dir = Vector2(dx, dy).normalized()
    
    length = Length
    canDash = false
    
    player.movementLocked = true
  else:
    if player.is_on_floor():
      canDash = true
