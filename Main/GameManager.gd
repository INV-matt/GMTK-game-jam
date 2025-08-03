extends Node
class_name GameManager

@export var HUD: CanvasLayer
@export var UI_PowerSelect: PowerSelectUI

@export var MinimumPowersLevel: int
@export var MinimumOnDeathPowersLevel: int

@export var PowersList: Array[PowerWrapper]
var ChosenPowers: Array[PowerWrapper]

@export var PossiblePowersForLevel: Dictionary[int, PackedStringArray]

var PassivePower: Power
var OnDeathPower: Power
var PL: Player
var _livesUsed = 1

func getLivesUsed() -> int: return _livesUsed


func _ready() -> void:
  PL = Globals.getPlayer() as Player
  SignalBus.player_death.connect(_on_player_death)
  SignalBus.next_level.connect(_on_next_level)
  ChosenPowers.resize(2)


func _on_player_death() -> void:
  _handlePowerMenuOpening()
  
  _livesUsed += 1
  HUD.UpdateLives()

func _on_next_level() -> void:
  #print("On level: " + str(Globals.getCurrentLevel()))
  call_deferred("_handlePowerMenuOpening")


func _handlePowerMenuOpening() -> void:
  # ADD HERE ALL THE CASES IN WHICH THE POWERS MENU SHOULD NOT BE DISPLAYED
  if Globals.getCurrentLevel() < MinimumPowersLevel: return

  SignalBus.open_power_select.emit()

func SetPassive(passive: Power) -> void:
  PassivePower = passive
  OnDeathPower = null
  SignalBus.hide_power_select.emit()

  # Remove previous powers from player
  for i in PL.get_children():
    if i is Power and "power" in i.get_groups():
      i.free()
      
  #Apply to player
  PL.add_child(PassivePower)
  PL._apply_powers_passive()
  HUD.UpdatePowers()

func SetPowers(passive: Power, onDeath: Power) -> void:
  PassivePower = passive
  OnDeathPower = onDeath
  SignalBus.hide_power_select.emit()

  # Remove previous powers from player
  for i in PL.get_children():
    if i is Power and "power" in i.get_groups():
      i.free()

  #Apply to player
  PL.add_child(PassivePower)
  PL.add_child(OnDeathPower)
  PL._apply_powers_passive()
  HUD.UpdatePowers()
  
func ChoosePowersToDisplay() -> Array[PowerWrapper]:
  var res: Array[PowerWrapper] = []
  var lvl = Globals.getCurrentLevel()

  for wrp in PowersList:
    if PossiblePowersForLevel[lvl][0] == 'ALL':
      res.push_back(wrp)
    elif wrp.name in PossiblePowersForLevel[lvl]:
      res.push_back(wrp)
  # res.shuffle()
  # for i in res: print(i.name)
  return res

  # var res = PowersList.duplicate(true)
  # res.shuffle()
  # return res

# Decides if the hud can show powers (it's better to hide it in the first 3 levels)
func CanShowPowers() -> bool:
  return Globals.getCurrentLevel() >= MinimumPowersLevel

func CanShowOnDeathPowers() -> bool:
  return Globals.getCurrentLevel() >= MinimumOnDeathPowersLevel

#! DEBUG
func _input(event: InputEvent) -> void:
  if event is InputEventKey && event.keycode == KEY_P: SignalBus.open_power_select.emit()
