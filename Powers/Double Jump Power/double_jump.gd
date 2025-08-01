extends Power

var p: Player

# Maybe this should be just "= 2" instead of "+ 1" idk
func _power_passive(player: Player) :
  player.MaxJumps += 1
  p = player

func _bouncePlayer(p: Player) :
  if p.velocity.y < 0 :
    return
  
  p.velocity.y = -p._jumpVelocity
  
  if Input.is_action_pressed("pl_jump") :
    p.velocity.y = -p._jumpVelocity * 1.5

func _power_death(p: Player) :
  var area = Area2D.new()
  var shape = CollisionShape2D.new()
  
  shape.shape = RectangleShape2D.new()
  (shape.shape as RectangleShape2D).size = Vector2(50, 20)
  
  area.add_child(shape)
  area.global_position = p.global_position
  area.collision_layer = 0
  area.collision_mask = 2
  area.connect("body_entered", func(x): _bouncePlayer(x))
  
  get_tree().get_root().call_deferred("add_child", area)

func _exit_tree() -> void:
  p.MaxJumps -= 1
