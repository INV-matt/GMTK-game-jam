extends Area2D

var canGrab = false

func _ready() -> void:
  SignalBus.next_level.connect(_on_next_level)

func _on_body_exited(body: Node2D) -> void:
  canGrab = true

var player: Player

func _on_body_entered(body: Player) -> void:
  if !canGrab:
    return
  
  body.SetScaleMultiplier(.5)
  player = body
  
  $Timer.start()
  
  set_deferred("monitoring", false)

func _on_timer_timeout() -> void:
  Globals.getPlayer().SetScaleMultiplier(1)
  
  queue_free()


func _on_next_level() -> void:
  Globals.getPlayer().SetScaleMultiplier(1)
  queue_free()
