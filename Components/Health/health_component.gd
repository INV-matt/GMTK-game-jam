extends Node

class_name HealthComponent

@export var MaxHealth = 100
@export var DestroyOnNoHealth = false

var health: int

func _ready() -> void:
  health = MaxHealth

signal death

func doDamage(amt: int) :
  health -= amt
  
  if health == 0 :
    emit_signal("death")
    
    if DestroyOnNoHealth :
      get_parent().queue_free()
