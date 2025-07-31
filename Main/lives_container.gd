extends HBoxContainer


@export var LivesLabel: Label

func _ready():
  LivesLabel.text = str(LivesManager.MaxPlayerLives)

  SignalBus.player_death.connect(_on_player_death)
  SignalBus.player_healt_changed.connect(_on_player_health_changed)


func _on_player_death() -> void:
  LivesLabel.text = str(LivesManager.remainingLives)


func _on_player_health_changed(health: int) -> void:
  #print(str(health))
  pass
