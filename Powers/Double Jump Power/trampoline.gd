extends Area2D

func _on_body_entered(p: Player) -> void:
  if p.velocity.y < 0 :
    return
  
  p.velocity.y = -p._jumpVelocity
  
  if Input.is_action_pressed("pl_jump") :
    p.velocity.y = -p._jumpVelocity * 1.5
