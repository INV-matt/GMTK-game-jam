extends Node

var _player: Player
var _main: Node2D
var _currentLevel: int
var _gameManager: GameManager

func _ready() -> void:
  _main = get_node("../Main") as Node2D
  
  # I just want to bedug in peace
  if not _main :
    return
  
  _player = _main.get_node("%Player") as Player
  _gameManager = _main.get_node("%GameManager") as GameManager

func getPlayer() -> Player:
  return _player

func getMain() -> Node2D:
  return _main

func getCurrentLevel() -> int:
  return _currentLevel

func setCurrentLevel(level: int) -> void:
  _currentLevel = level

func getGameManager() -> GameManager:
  return _gameManager
