extends Node
class_name GameManager

@export var HUD: CanvasLayer
@export var UI_PowerSelect: PowerSelectUI

@export var MinimumPowersLevel: int

@export var PowersList: Array[PowerWrapper]
var ChosenPowers: Array[PowerWrapper]

var PassivePower: Power
var OnDeathPower: Power
var PL: Player
var _livesUsed = 1

func getLivesUsed() -> int: return _livesUsed


func _ready() -> void:
  PL = Globals.getPlayer() as Player
  SignalBus.player_death.connect(_on_player_death)
  SignalBus.next_level.connect(_on_next_level)


func _on_player_death() -> void:
  _handlePowerMenuOpening()
  
  _livesUsed += 1
  HUD.UpdateLives()

func _on_next_level() -> void:
  _handlePowerMenuOpening()
  print("On level: " + str(Globals.getCurrentLevel()))


func _handlePowerMenuOpening() -> void:
  # ADD HERE ALL THE CASES IN WHICH THE POWERS MENU SHOULD NOT BE DISPLAYED
  if Globals.getCurrentLevel() < MinimumPowersLevel: return

  SignalBus.open_power_select.emit()

func SetPowers(passive: Power, onDeath: Power) -> void:
  PassivePower = passive
  OnDeathPower = onDeath
  SignalBus.hide_power_select.emit()

  # Remove previous powers from player
  for i in PL.get_children():
    if i is Power and "power" in i.get_groups():
      i.queue_free()

  #Apply to player
  
  PL.add_child(PassivePower)
  PL.add_child(OnDeathPower)
  PL._apply_powers_passive()

func ChoosePowersToDisplay() -> Array[PowerWrapper]:
  var res = PowersList.duplicate()
  res.shuffle()
  return res


#! DEBUG
func _input(event: InputEvent) -> void:
  if event.is_action_pressed("pl_dash"): SignalBus.open_power_select.emit()
