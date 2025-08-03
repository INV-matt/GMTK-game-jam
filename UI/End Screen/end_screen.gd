extends Control

func _on_texture_button_pressed() -> void:
  MusicManager.playTrack("mainmenu")
  get_tree().change_scene_to_file("res://UI/Main Menu/main_menu.tscn")
