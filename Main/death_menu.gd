extends CanvasLayer

@export var btn_Restart: Button

func _ready():
  visible = false


func _on_restart_btn_button_down() -> void:
  BodyManager.ResetLevel()
