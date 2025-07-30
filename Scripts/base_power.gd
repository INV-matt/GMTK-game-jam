extends Node

class_name Power

func get_player() :
  var parent = get_parent()

  if not parent is Player :
    return

  return parent

# Apply the power's passive effects eg. activating a double jump
func apply_power_passive() :
  pass

# Apply the power's on-death effects eg. exploding violently
func apply_power_death() :
  pass
