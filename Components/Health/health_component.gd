extends Node

class_name HealthComponent

@export var MaxHealth = 100
@export var DestroyOnNoHealth = false
@export var DisplayHealthBar: ProgressBar

var health: int

func _ready() -> void:
  health = MaxHealth
  
  if DisplayHealthBar :
    DisplayHealthBar.max_value = MaxHealth
    DisplayHealthBar.value = health
    DisplayHealthBar.visible = true

signal death
signal damaged

func doDamage(amt: int) :
  health -= amt
  DisplayHealthBar.value = health
  
  if health == 0 :
    emit_signal("death")
    
    if DestroyOnNoHealth :
      get_parent().queue_free()
  else :
    emit_signal("damaged")
