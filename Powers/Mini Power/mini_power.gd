extends Power

var player: Player

func _power_passive(p: Player) :
  p.scale /= 2
  player = p

func _exit_tree() -> void:
  player.scale *= 2

var shroomScene = preload("res://Powers/Mini Power/mini_shroom.tscn")

func _power_death(p: Player) :
  var shroom = shroomScene.instantiate()
  
  shroom.global_position = p.global_position
  
  get_tree().get_root().call_deferred("add_child", shroom)
