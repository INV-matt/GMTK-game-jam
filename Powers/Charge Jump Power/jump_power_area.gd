extends Area2D

@export var JumpVelMult = 1.25

func _on_body_entered(p: Player) -> void:
  p._jumpVelocity *= JumpVelMult

func _on_body_exited (p: Player) -> void:
  p._jumpVelocity /= JumpVelMult
