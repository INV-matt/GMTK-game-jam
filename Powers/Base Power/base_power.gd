extends Node

class_name Power

func _get_player() :
  var parent = get_parent()

  if not parent is Player :
    return

  return parent

# Apply the power's passive effects eg. activating a double jump
func apply_power_passive() -> void :
  var player = _get_player()
  
  if player :
    _power_passive(player)

# Apply the power's on-death effects eg. exploding violently
func apply_power_death() -> void :
  var player = _get_player()
  
  if player :
    _power_death(player)

# Override this one /w passive power effects
func _power_passive(player: Player) -> void :
  pass

# Override this one /w on death effects
func _power_death(player: Player) -> void :
  pass
