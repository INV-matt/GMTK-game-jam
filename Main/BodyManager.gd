extends Node

var respawnPosition: Vector2
var player: Player
var playerhealth: HealthComponent

func get_all_children(in_node, array := []):
  array.push_back(in_node)
  for child in in_node.get_children():
    array = get_all_children(child, array)
  return array

func _respawnPlayer() :
  playerhealth.healAll()
  player.global_position = respawnPosition

func _onPlayerDeath() :
  var pos = player.global_position
  
  if pos == Vector2.ZERO :
    return
  
  _respawnPlayer()
  
  var body = StaticBody2D.new()
  var shape: CollisionShape2D = CollisionShape2D.new()
  
  for i in player.get_children() :
    if i is CollisionShape2D :
      shape.shape = i.shape
      shape.shape.radius = i.shape.radius
      shape.shape.height = i.shape.height
  
  body.add_child(shape)
  body.global_position = pos
  
  get_tree().get_root().add_child(body)

func _resetLevel() :
  var root = get_tree().get_root()
  
  for element in get_all_children(root):
    if element is Player :
      respawnPosition = element.global_position
      player = element
      
      for i in element.get_children() :
        if i is HealthComponent :
          playerhealth = i
          i.death.connect(_onPlayerDeath)

func _ready() -> void:
  _resetLevel()
