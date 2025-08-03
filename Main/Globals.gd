extends Node

var _player: Player
var _main: Node2D
var _currentLevel: int
var _gameManager: GameManager

var ScenesWhereToNotLoad: Array[String] = ["res://UI/Main Menu/main_menu.tscn", "res://UI/Main Menu/level_select.tscn", "res://UI/Intro Cutscene/intro_cutscene.tscn", "res://UI/Main Menu/record_view.tscn"]

func _ready() -> void:
  # Disable if in main menu
  if !get_tree().current_scene or get_tree().current_scene.scene_file_path in ScenesWhereToNotLoad :
    return
  
  _main = get_node("../Main") as Node2D
  
  # I just want to bedug in peace | me too, me too
  # This should only happen when running the project outside of the main scene
  if not _main:
    _main = get_node("../power_testing") as Node2D
  
  _player = _main.get_node("%Player") as Player
  _gameManager = _main.get_node("%GameManager") as GameManager

func getPlayer() -> Player:
  if not _main :
    _ready()
    
  return _player

func getMain() -> Node2D:
  if not _main :
    _ready()
    
  return _main

func getCurrentLevel() -> int:
  if not _main :
    _ready()
    
  return _currentLevel

func setCurrentLevel(level: int) -> void:
  if not _main :
    _ready()
    
  _currentLevel = level

func getGameManager() -> GameManager:
  if not _main :
    _ready()
    
  return _gameManager
