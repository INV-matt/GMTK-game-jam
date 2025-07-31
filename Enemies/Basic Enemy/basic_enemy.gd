extends CharacterBody2D

class_name Enemy

@export var Speed = 100
@export var DmgAmt = 5

var _horizontalDirection = 1

func _handleMovement(delta: float) :
  velocity.y += get_gravity().y * delta
  
  velocity.x = _horizontalDirection * Speed
  
  var last_pos = global_position
  
  move_and_slide()
  
  # Flip when hitting a wall (AKA we have not moved because we were blocked)
  if last_pos == global_position :
    _horizontalDirection *= -1

func _physics_process(delta: float) -> void:
  _handleMovement(delta)

func _on_hitbox_body_entered(body: Player) -> void:
  for i in body.get_children() :
    if i is HealthComponent :
      i.doDamage(DmgAmt)
