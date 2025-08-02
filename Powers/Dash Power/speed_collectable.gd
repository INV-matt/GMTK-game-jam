extends Area2D

@export var SpeedMult = 1.25
@export var duration = 2.5

var canCollect = false

var player: Player

func _on_body_entered(p: Player) -> void:
  if !canCollect :
    return
    
  player = p
  
  p.Speed *= SpeedMult
  p.Acceleration *= SpeedMult

  $Timer.start(duration)
  
  monitoring = false
  visible = false

func _on_body_exited(body: Node2D) -> void:
  canCollect = true

func _on_timer_timeout() -> void:
  if !player :
    return
  
  player.Speed /= SpeedMult
  player.Acceleration /= SpeedMult
  queue_free()
