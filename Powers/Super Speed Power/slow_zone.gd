extends Area2D

@export var SpeedMult = .5

func _on_body_entered(body: Enemy) -> void:
  body.Speed *= SpeedMult

func _on_body_exited(body: Enemy) -> void:
  body.Speed /= SpeedMult
