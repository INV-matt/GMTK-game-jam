extends PointLight2D

var following = false
var player: Player
var canGrab = false

func _process(delta: float) -> void:
  if !following :
    return
    
  global_position = player.global_position

func _on_area_2d_body_entered(body: Node2D) -> void:
  if !canGrab :
    return
    
  $Timer.start()
  
  following = true
  player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
  canGrab = true

func _on_timer_timeout() -> void:
  queue_free()
