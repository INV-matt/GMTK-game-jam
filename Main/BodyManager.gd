extends Node

var respawnPosition: Vector2
var player: Player
var playerhealth: HealthComponent

func get_all_children(in_node, array := []):
  array.push_back(in_node)
  for child in in_node.get_children():
    array = get_all_children(child, array)
  return array

func _respawnPlayer():
  playerhealth.healAll()
  player.global_position = respawnPosition

var _bodyTexture = preload("res://Main/Blank-CorpseSheet.png")

signal apply_powers

func _onPlayerDeath():
  var pos = player.global_position
  
  if Vector2.ZERO.distance_squared_to(pos) < 100:
    return
  
  emit_signal("apply_powers")
  
  _respawnPlayer()
  
  var body = StaticBody2D.new()
  var shape: CollisionShape2D = CollisionShape2D.new()
  var sprite: Sprite2D = Sprite2D.new()
  
  for i in player.get_children():
    if i is CollisionShape2D:
      shape.shape = i.shape
      shape.shape.radius = i.shape.radius
      shape.shape.height = i.shape.height
  
  sprite.texture = _bodyTexture
  sprite.texture.set("size", Vector2(shape.shape.radius * 2, shape.shape.height))
  sprite.rotation_degrees = -90
  sprite.position.x = -10
  
  body.add_child(shape)
  body.add_child(sprite)
  body.global_position = pos
  body.global_position.y += 10
  body.rotation_degrees = 90
  body.add_to_group("bodies")
  
  #get_tree().get_root().add_child(body)

  get_tree().get_root().call_deferred("add_child", body)


func _resetLevel():
  player = Globals.getPlayer()
  # var root = get_tree().get_root()
  
  # for element in get_all_children(root):
  #   if element is Player:
  #     respawnPosition = element.global_position
  #     player = element
      
  #     for i in element.get_children():
  #       if i is HealthComponent:
  #         playerhealth = i
  #         i.death.connect(_onPlayerDeath)
  respawnPosition = player.global_position
  for i in player.get_children():
    if i is HealthComponent:
      playerhealth = i
      playerhealth.death.connect(_onPlayerDeath)

func _ready() -> void:
  _resetLevel()
