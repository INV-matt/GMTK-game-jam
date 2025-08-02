extends Node

@export var levels: Array[PackedScene]
@export var startingLevel = 0

@onready var addTo: Node2D = %levelcontainer
@onready var player: Player = %Player

var currLevel: int
var GM: GameManager

var LevelScores: Dictionary = {}

func loadSaveFile() :
  var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
  var json_string = save_file.get_line()
  
  var json = JSON.new()
  
  var parse_result = json.parse(json_string)
  if parse_result != OK :
    print("Error loading savefile")
    return
  
  LevelScores = json.data
  
  print("Loaded savefile:")
  print(LevelScores)

func saveScores() :
  var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
  var json_string = JSON.stringify(LevelScores)
  
  save_file.store_line(json_string)
  
  print("Saved savefile")
  print(json_string)

func _nextLevel():
  var usedThisLevel = GM.getLivesUsed()
  GM.resetLivesUsed()
  
  if currLevel in LevelScores :
    LevelScores[currLevel] = min(LevelScores[currLevel], usedThisLevel)
  else :
    LevelScores[currLevel] = usedThisLevel  
  
  saveScores()
  
  currLevel += 1
  Globals.setCurrentLevel(currLevel)
  
  SignalBus.next_level.emit()
  _loadLevel()

func _loadLevel():
  if currLevel >= len(levels):
    return
    
  player.position = Vector2.ZERO
  player.velocity = Vector2.ZERO
  
  var lvl = levels[currLevel].instantiate()
  
  for i in lvl.get_children():
    if "cookie" in i.get_groups() and i is Cookie:
      i.connect("next_level", _nextLevel)
  # SignalBus.connect("next_level", _nextLevel)
  
  # for k in addTo.get_children():
  #   addTo.remove_child(k)
  for k in addTo.get_children():
    #k.queue_free()
    addTo.call_deferred("remove_child", k)
  
  var root = get_tree().get_root()
  for i in root.get_children():
    if i is StaticBody2D and "bodies" in i.get_groups():
      root.remove_child(i)
  
 #addTo.add_child(lvl)
  addTo.call_deferred("add_child", lvl)

func _ready() -> void:
  var root = get_tree().get_root()
  
  for i in root.get_children():
    if "levelcontainer" in i.get_groups():
      addTo = i
      
  currLevel = startingLevel
  Globals.setCurrentLevel(currLevel)
  
  GM = Globals.getGameManager()
  
  if !FileAccess.file_exists("user://savegame.save") :
    print("No save file found")
  else :
    loadSaveFile()
  
  _loadLevel()
