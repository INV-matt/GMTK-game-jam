extends Node2D

class_name Hazard

func _on_hurtbox_body_entered(body: Player) -> void:
  for i in body.get_children() :
    if i is HealthComponent :
      i.doDamage(i.health)
