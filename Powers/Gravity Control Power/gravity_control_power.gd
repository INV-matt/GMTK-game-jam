extends Power

var isActive = false
var player: Player

func _power_passive(p: Player):
  isActive = true
  player = p
 
func _process(delta: float) -> void:
  if !isActive:
    return
  
  if Input.is_action_just_pressed("pl_attack"):
    player.GlobalGravityDir = -player.GlobalGravityDir

var antiScene = preload("res://Powers/Gravity Control Power/antigravity_area.tscn")

func _power_death(p: Player):
  var anti: Area2D = antiScene.instantiate()
  
  anti.global_position = p.global_position
  
  get_tree().get_root().call_deferred("add_child", anti)