extends Power

var active = false
var player: Player

func _power_passive(p: Player) :
  active = true
  player = p

func _process(delta: float) -> void:
  if !active :
    return
  
  if player.GlobalGravityMult == 1 :
    player.GlobalGravityMult = .5

var boardScene = preload("res://Powers/Float Power/surfboard.tscn")

func _power_death(p: Player) :
  var board: CharacterBody2D = boardScene.instantiate()
  
  board.global_position = p.global_position
  board.position.y -= 50
  
  get_tree().get_root().call_deferred("add_child", board)

func _exit_tree() :
  player.GlobalGravityMult = 1
