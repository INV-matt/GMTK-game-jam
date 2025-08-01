extends Area2D

func _on_body_entered(body: Player) -> void:
  body.GlobalGravityDir = -1

func _on_body_exited(body: Player) -> void:
  body.GlobalGravityDir = 1
