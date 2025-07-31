extends Power

# Maybe this should be just "= 2" instead of "+ 1" idk
func _power_passive(player: Player) :
  player.MaxJumps += 1
