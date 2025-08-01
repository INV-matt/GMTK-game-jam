extends Power

var p: Player

# Maybe this should be just "= 2" instead of "+ 1" idk
func _power_passive(player: Player) :
  player.MaxJumps += 1
  p = player

func _power_death(p: Player) :
  var area = Area2D.new()
  var shape = CollisionShape2D.new()
  
  shape.shape = RectangleShape2D.new()
  (shape.shape as RectangleShape2D).size = Vector2(50, 20)
  
  area.add_child(shape)
  area.global_position = p.global_position
  area.collision_layer = 0
  area.collision_mask = 2
  area.connect("body_entered", func(x): p._jumpCount = -1; p._jump())
  
  get_tree().get_root().add_child(area)

func _exit_tree() -> void:
  p.MaxJumps -= 1
