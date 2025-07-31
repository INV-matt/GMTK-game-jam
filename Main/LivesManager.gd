extends Node

@export var MaxPlayerLives = 3
var remainingLives: int


func _ready() -> void:
  remainingLives = MaxPlayerLives

  SignalBus.player_death.connect(RemoveLife)

func RemoveLife() -> void:
  remainingLives -= 1
  print(remainingLives)
  if remainingLives <= 0: _handleAllLivesLost()


func _handleAllLivesLost() -> void:
  print("YOU DED DED frfr")
  BodyManager.ResetLevel()