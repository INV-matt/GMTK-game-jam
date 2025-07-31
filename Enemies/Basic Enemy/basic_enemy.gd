extends CharacterBody2D

class_name Enemy

@export var Speed = 100
@export var DmgAmt = 5

var _horizontalDirection = 1

func _setAnimation(name: String) :
  if $Sprite2D.animation == name :
    return
  
  $Sprite2D.play(name)

func _handleMovement(delta: float) :
  velocity.y += get_gravity().y * delta
  
  velocity.x = _horizontalDirection * Speed
  
  var last_pos = global_position
  
  move_and_slide()
  
  if _horizontalDirection > 0 :
    $Sprite2D.flip_h = true
  else :
    $Sprite2D.flip_h = false
  
  if is_on_floor() :
    if velocity.x == 0 :
      _setAnimation("idle")
    else :
      _setAnimation("walk")
  else :
    _setAnimation("fall")
  
  # Flip when hitting a wall (AKA we have not moved because we were blocked)
  if last_pos == global_position :
    _horizontalDirection *= -1

func _ready() -> void:
  $HealthComponent.connect("death", _onDeath)

func _onDeath() :
  _setAnimation("death")
  $Sprite2D.connect("animation_finished", queue_free)

func _physics_process(delta: float) -> void:
  if $HealthComponent.isdead :
    return
  
  _handleMovement(delta)

func _on_hitbox_body_entered(body: Player) -> void:
  if $HealthComponent.isdead :
    return
    
  for i in body.get_children() :
    if i is HealthComponent :
      i.doDamage(DmgAmt)
