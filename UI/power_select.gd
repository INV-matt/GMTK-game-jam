extends Control

var slotsOccupied: Array[bool] = [false, false]
var slotsBtn: Array[TextureButton] = []

@export var BlankSlot: CompressedTexture2D
var BlankWrapper = PowerWrapper.new()
@export var btn_proceed: Button
@export var scn_btn_power: PackedScene

var GM: GameManager
var toDisplay: Array[PowerWrapper]
var chosenUpgrades: Array[PackedScene]
var chosenPowerWrappers: Array[PowerWrapper]

func _ready() -> void:
  GM = Globals.getGameManager()
  slotsBtn.resize(2)
  chosenUpgrades.resize(2)
  chosenPowerWrappers.resize(2)

  BlankWrapper.name = "@NULL"
  BlankWrapper.texture = BlankSlot
  BlankWrapper.power = null
  GenerateNew()
  #Populate()


# Could be done better
func _process(_delta) -> void:
  btn_proceed.disabled = !(slotsOccupied[0] && slotsOccupied[1])


func _selectPower(idx: int):
  var wrapper = toDisplay[idx]
  for i in range(len(slotsOccupied)):
    if !slotsOccupied[i]:
      slotsOccupied[i] = true
      var btn_slot = slotsBtn[i]
      btn_slot.texture_normal = wrapper.texture

      chosenUpgrades[i] = wrapper.power
      chosenPowerWrappers[i] = wrapper

      if i == 0:
        (btn_slot.get_child(0) as RichTextLabel).text = "[center]Active ability: " + wrapper.name + "[/center]"
      else:
        (btn_slot.get_child(0) as RichTextLabel).text = "[center]On death ability: " + wrapper.name + "[/center]"
      return

func _unselectPower(idx: int):
  slotsOccupied[idx] = false
  var btn := slotsBtn[idx]
  btn.texture_normal = BlankSlot

  chosenUpgrades[idx] = BlankWrapper


  if idx == 0:
    (btn.get_child(0) as RichTextLabel).text = "[center]Active ability: None[/center]"
  else:
    (btn.get_child(0) as RichTextLabel).text = "[center]On death ability: None[/center]"
  return
  

func _on_select_powers_pressed() -> void:
  for b in slotsOccupied:
    if !b:
      print("Slot empty")
      return

  var powerPassive: Power = chosenUpgrades[0].instantiate()
  var powerOnDeath: Power = chosenUpgrades[1].instantiate()

  powerPassive.OnDeathEnabled = false # Disable ondeath effect
  powerOnDeath.PassiveEnabled = false # Disable passive effect
  GM.ChosenPowers[0] = chosenPowerWrappers[0]
  GM.ChosenPowers[1] = chosenPowerWrappers[1]

  GM.SetPowers(powerPassive, powerOnDeath)

func GenerateNew():
  toDisplay.clear()
  toDisplay = GM.ChoosePowersToDisplay()
  Populate()
  # print(" TO DISPLAY: ")
  # for i in toDisplay: print(i.name)

func Populate():
  var box_displayedPowers = $VBoxContainer/availablePowers
  var box_selectedPowers = $VBoxContainer/selectedPowers

  for el in box_displayedPowers.get_children(): el.queue_free()

  #var btn_arr_displayed = box_displayedPowers.get_children()
  var btn_arr_selected = box_selectedPowers.get_children()
  print(len(toDisplay))
  # Connect displayed powers' buttons
  for i in range(len(toDisplay)):
    # if btn_arr_displayed[i] is TextureButton:
    #   var btn: TextureButton = btn_arr_displayed[i]
    #   btn.texture_normal = toDisplay[i].texture
    #   (btn.get_child(0) as RichTextLabel).text = "[center]" + toDisplay[i].name + "[/center]"

    #   # btn.pressed.connect(_selectPower.bind(toDisplay[i])) # !TO FIX: When reshuffled, the bind doesn't change
    #   btn.pressed.connect(_selectPower.bind(i))
    var btn = scn_btn_power.instantiate() as TextureButton
    box_displayedPowers.add_child(btn)
    btn.texture_normal = toDisplay[i].texture
    (btn.get_child(0) as RichTextLabel).text = "[center]" + toDisplay[i].name + "[/center]"
    btn.pressed.connect(_selectPower.bind(i))


  # Connect selected powers' buttons
  for i in range(len(btn_arr_selected)):
    if btn_arr_selected[i] is TextureButton:
      var btn: TextureButton = btn_arr_selected[i]
      btn.pressed.connect(_unselectPower.bind(i))

      btn.texture_normal = BlankSlot

      slotsOccupied[i] = false
      slotsBtn[i] = btn
  
  (slotsBtn[0].get_child(0) as RichTextLabel).text = "[center]Active ability: None[/center]"
  (slotsBtn[1].get_child(0) as RichTextLabel).text = "[center]On death ability: None[/center]"
