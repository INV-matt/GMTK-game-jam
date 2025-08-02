extends Control

@onready var LM: LevelManager = $LevelManager

func _ready() -> void:
  var num = 1
  
  for i in LM.levels :
    var lvl = i.instantiate()
    
    var button = Button.new()
    
    button.text = "Level " + str(num)
    button.connect("pressed", func(): get_tree().change_scene_to_file("res://Main/main.tscn"); (%LevelManager as LevelManager).currLevel = num-1;  (%LevelManager as LevelManager)._loadLevel())

    add_child(button)

    num += 1
