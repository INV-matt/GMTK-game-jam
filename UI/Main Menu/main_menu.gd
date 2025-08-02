extends Control

func _on_start_pressed() -> void:
  get_tree().change_scene_to_file("res://Main/main.tscn")
  # Calling this also resets BodyManager
  Globals._ready() # Reload globals, eg. player
