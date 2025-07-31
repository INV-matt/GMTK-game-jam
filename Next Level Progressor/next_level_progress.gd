extends Node2D

class_name LevelProgressor

signal next_level

func _on_collider_body_entered(body: Node2D) -> void:
  print("Go to the next level")
  emit_signal("next_level")
