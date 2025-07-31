extends Node

class_name HealthComponent

## I do not think you need an explanation for this one
@export var MaxHealth = 100

## Whether to destroy the parent when health reaches 0
@export var DestroyOnNoHealth = false

## The ProgressBar to use to display heath
@export var DisplayHealthBar: ProgressBar

## If this is true then the healthbar will always be shown, otherwise it will be show if not at 100% hp
@export var AlwaysShow = false

@export var IsPlayer = false

var health: int
var isdead = false

func _updateBar():
  isdead = health <= 0
  
  if DisplayHealthBar:
    DisplayHealthBar.value = health
    DisplayHealthBar.visible = health < MaxHealth or AlwaysShow

func healAll():
  health = MaxHealth
  _updateBar()

func _ready() -> void:
  health = MaxHealth
  
  if DisplayHealthBar:
    DisplayHealthBar.max_value = MaxHealth
    
  _updateBar()

signal death
signal damaged

func doDamage(amt: int):
  health -= amt
  if IsPlayer: SignalBus.emit_signal("player_healt_changed", health)
  _updateBar()
  
  if health <= 0:
    emit_signal("death")
    if IsPlayer: SignalBus.emit_signal("player_death")
    
    if DestroyOnNoHealth:
      get_parent().queue_free()
  else:
    emit_signal("damaged")
