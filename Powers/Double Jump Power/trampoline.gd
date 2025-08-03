extends Area2D

func _on_body_entered(p: Player) -> void:
  if p.velocity.y < 0 :
    return
  
  $AnimatedSprite2D.play("bounce")
  
  p.velocity.y = -p._jumpVelocity
  
  if Input.is_action_pressed("pl_jump") :
    p.velocity.y = -p._jumpVelocity * 1.5

func _on_animated_sprite_2d_animation_finished() -> void:
  $AnimatedSprite2D.play("default")
