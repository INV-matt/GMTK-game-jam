extends Node

@export var levels: Array[PackedScene]
@export var startingLevel = 0

@onready var addTo: Node2D = %levelcontainer
@onready var player: Player = %Player

var currLevel: int

func _nextLevel():
  currLevel += 1
  Globals.setCurrentLevel(currLevel)
  _loadLevel()

func _loadLevel():
  if currLevel >= len(levels):
    return
    
  player.position = Vector2.ZERO
  
  var lvl = levels[currLevel].instantiate()
  
  for i in lvl.get_children():
    if "cookie" in i.get_groups() and i is Cookie:
      i.connect("next_level", _nextLevel)
  
  for k in addTo.get_children():
    addTo.remove_child(k)
  
  var root = get_tree().get_root()
  for i in root.get_children():
    if i is StaticBody2D and "bodies" in i.get_groups():
      root.remove_child(i)
  
  addTo.add_child(lvl)

func _ready() -> void:
  var root = get_tree().get_root()
  
  for i in root.get_children():
    if "levelcontainer" in i.get_groups():
      addTo = i
      
  currLevel = startingLevel
  Globals.setCurrentLevel(currLevel)
  
  _loadLevel()
