extends Control

var LM = LevelManager.new()
@onready var container = $MarginContainer/Grid
var content_size: Vector2

func _ready() -> void:
  LM.loadSaveFile()
  
  for i in LM.LevelScores:
    var control = Control.new()
    var text = RichTextLabel.new()
    var color = ColorRect.new()
    
    text.text = "Level " + str(int(i) + 1) + "\n" + str(int(LM.LevelScores[i])) + " death"
    
    if int(LM.LevelScores[i]) != 1:
      text.text += "s"
    
    text.fit_content = true
    text.size = Vector2(76, 36)
    
    color.color = Color(0, 0, 0, .65)
    color.z_index = -1
    color.set_anchors_preset(Control.PRESET_FULL_RECT)
    
    text.add_child(color)
    control.add_child(text)
    container.add_child(control)
    content_size = control.size

func _on_texture_button_pressed() -> void:
  get_tree().change_scene_to_file("res://UI/Main Menu/main_menu.tscn")


func _process(_delta: float) -> void:
  var newSize = (DisplayServer.window_get_size() - Vector2i(40, 40))
  var cols: int = container.columns
  var rows: int = int(container.get_child_count() / cols) + 1
  var h_sep = (newSize.x / (cols) + 1) - content_size.x
  var v_sep = (newSize.y / (rows) + 1) - content_size.y
  container.add_theme_constant_override("h_separation", h_sep)
  container.add_theme_constant_override("v_separation", v_sep)
