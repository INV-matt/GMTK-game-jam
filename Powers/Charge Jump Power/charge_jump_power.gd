extends Power

@export var MaxVelocityMult = 2

var isActive = false
var player: Player
var originalvelocity = 0
var currentVelocity = 0

func _power_passive(p: Player):
  isActive = true
  # player = p
  player = Globals.getPlayer()
  
  originalvelocity = player._jumpVelocity
  
  player._jumpVelocity = 0

func _process(delta: float) -> void:
  if !isActive:
    return

  var pl = Globals.getPlayer()
    
  pl._jumpVelocity = currentVelocity
  pl.scale.y = 1 - currentVelocity / (originalvelocity * MaxVelocityMult) * .5
  
  if Input.is_action_pressed("pl_jump"):
    if pl.is_on_floor():
      currentVelocity += originalvelocity / 60
      if currentVelocity >= originalvelocity * MaxVelocityMult:
        currentVelocity = originalvelocity * MaxVelocityMult
  elif currentVelocity > originalvelocity / 60:
    pl._jump()
    currentVelocity = 0

func _exit_tree() -> void:
  var pl = Globals.getPlayer()
  pl.getPlayer().SetScaleMultiplier(1)
  pl.getPlayer()._jumpVelocity = originalvelocity


var jumpZoneScene = preload("res://Powers/Charge Jump Power/jump_power_area.tscn")

func _power_death(p: Player) :
  var zone: Area2D = jumpZoneScene.instantiate()
  
  zone.global_position = p.global_position
  
  get_tree().get_root().add_child(zone)
