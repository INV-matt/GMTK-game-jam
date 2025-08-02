extends Control

func _on_start_pressed() -> void:
  get_tree().change_scene_to_file("res://Main/main.tscn")
  # Calling this also resets BodyManager
  Globals._ready() # Reload globals, eg. player

func _on_level_select_pressed() -> void:
  get_tree().change_scene_to_file("res://UI/Main Menu/level_select.tscn")

func _on_quit_pressed() -> void:
  get_tree().quit()
