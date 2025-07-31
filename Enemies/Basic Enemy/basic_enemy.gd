extends CharacterBody2D

class_name Enemy

@export var Speed = 100

var _horizontalDirection = 1

func _physics_process(delta: float) -> void:
  velocity.y += get_gravity().y * delta
  
  velocity.x = _horizontalDirection * Speed
  
  var last_pos = global_position
  
  move_and_slide()
  
  if last_pos == global_position :
    _horizontalDirection *= -1
