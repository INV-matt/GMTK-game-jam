extends HBoxContainer


@export var LivesLabel: Label

func _ready():
  LivesLabel.text = str(LivesManager.MaxPlayerLives)

  SignalBus.player_death.connect(_on_player_death)
  SignalBus.player_healt_changed.connect(_on_player_health_changed)


func _on_player_death() -> void:
  LivesManager.RemoveLife()
  LivesLabel.text = str(LivesManager.remainingLives)
  print("bruh")


func _on_player_health_changed(health: int) -> void:
  #print(str(health))
  pass
