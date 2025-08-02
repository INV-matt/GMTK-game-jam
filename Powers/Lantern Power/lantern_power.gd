extends Power

func _power_passive(p: Player) -> void:
  $PointLight2D.visible = true

var lanternScene = preload("res://Powers/Lantern Power/dropped_lantern.tscn")

func _power_death(p: Player):
  var lantern: PointLight2D = lanternScene.instantiate()
  
  lantern.global_position = p.global_position
  
  get_tree().get_root().add_child(lantern)
