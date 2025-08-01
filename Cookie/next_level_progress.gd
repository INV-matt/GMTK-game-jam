extends Node2D

class_name Cookie

# signal next_level

func _waitForNextGlint():
  var time = randi_range(1, 10)
  $glintTimer.start(time)

func _ready() -> void:
  _waitForNextGlint()

func _on_collider_body_entered(body: Node2D) -> void:
  print("Go to the next level")
  # emit_signal("next_level")
  SignalBus.emit_signal("next_level")

func _on_glint_timer_timeout() -> void:
  $Sprite2D.play("glister")
  _waitForNextGlint()

func _on_sprite_2d_animation_finished() -> void:
  $Sprite2D.play("idle")
