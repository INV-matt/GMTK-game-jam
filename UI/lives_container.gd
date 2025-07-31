extends HBoxContainer

#TODO move lives counter to a better place
@export var MaxPlayerLives = 3

@export var LivesLabel: Label

var _remainingLives = 0

func _ready():
  _remainingLives = MaxPlayerLives
  LivesLabel.text = str(MaxPlayerLives)

  SignalBus.player_death.connect(Callable(self, "_on_player_death"))
  SignalBus.player_healt_changed.connect(Callable(self, "_on_player_health_changed"))


func _on_player_death() -> void:
  _remainingLives -= 1
  LivesLabel.text = str(_remainingLives)
  print("bruh")


func _on_player_health_changed(health: int) -> void:
  #print(str(health))
  pass
