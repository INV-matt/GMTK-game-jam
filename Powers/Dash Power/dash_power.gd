extends Power

@export var Speed = 300
@export var Length = 10

var isReady = false
var player: Player
var canDash = true

var length = 0
var dir = Vector2.ZERO

func _power_passive(p: Player):
  isReady = true
  player = p

var collectScene = preload("res://Powers/Dash Power/speed_collectable.tscn")

func _power_death(p: Player):
  var collect: Area2D = collectScene.instantiate()
  
  collect.global_position = p.global_position
  
  get_tree().get_root().call_deferred("add_child", collect)

var trailScene = preload("res://Powers/Dash Power/dash_trail.tscn")

@onready var dashSound: RandomizedAuiodStreamPlayer = $RandomizedPlayer

func _process(delta: float) -> void:
  if not isReady:
    return
    
  if length > 0:
    player.set_collision_mask_value(5, false)
    length -= 1
    player.velocity = dir * Speed
    player.move_and_slide()
    
    if length % 2 == 0:
      var trail: AnimatedSprite2D = trailScene.instantiate()
      trail.global_position = player.global_position
      trail.rotation = player.velocity.angle()
      
      get_tree().get_root().call_deferred("add_child", trail)
    
    return
  else:
    player.movementLocked = false
    player.set_collision_mask_value(5, true)

    
  var dx = Input.get_axis("pl_left", "pl_right")
  var dy = Input.get_axis("pl_up", "pl_down")
  
  if canDash and Input.is_action_pressed("pl_dash") and abs(dx) + abs(dy) > 0:
    dashSound.playRandom()
    dir = Vector2(dx, dy).normalized()
    
    length = Length
    canDash = false
    
    player.movementLocked = true
  else:
    if player.is_on_floor():
      canDash = true
