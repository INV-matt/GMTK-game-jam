extends Area2D

var canGrab = false

func _on_body_exited(body: Node2D) -> void:
  canGrab = true

var player: Player

func _on_body_entered(body: Player) -> void:
  if !canGrab:
    return
  
  body.SetScaleMultiplier(.5)
  player = body
  
  $Timer.start()
  
  monitoring = false

func _on_timer_timeout() -> void:
  player.SetScaleMultiplier(1)
  
  queue_free()
