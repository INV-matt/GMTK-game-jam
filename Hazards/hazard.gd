extends Node2D

class_name Hazard

func _on_hurtbox_body_entered(body: Player) -> void:
  # Decide if we want to keep it in
  if body.velocity.y < 0: return

  for i in body.get_children():
    if i is HealthComponent:
      i.doDamage(i.health)
