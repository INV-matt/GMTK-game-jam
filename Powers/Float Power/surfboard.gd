extends CharacterBody2D

var active = false
var player_offset = Vector2.ZERO
var player = Globals.getPlayer()

func _on_grab_area_body_entered(body: Player) -> void:
  player_offset = body.global_position - global_position
  active = true
  
  $Timer.start()

func _process(delta: float) -> void:
  if !active :
    return
    
  player._setAnimation("idle")
  
  player.velocity = Vector2.ZERO
  player.global_position = global_position + player_offset
  
  var dx = Input.get_axis("pl_left", "pl_right")
  var dy = Input.get_axis("pl_up", "pl_down")
  
  var dir = Vector2(dx, dy).normalized() * player.Speed
  
  velocity = dir
  
  move_and_slide()

func _on_timer_timeout() -> void:
  queue_free()
