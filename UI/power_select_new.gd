extends Control

var slotsOccupied: Array[bool] = []
var slotsBtn: Array[TextureButton] = []

@export var BlankSlot: CompressedTexture2D
var BlankWrapper = PowerWrapper.new()
@export var btn_proceed: Button

var GM: GameManager
var toDisplay: Array[PowerWrapper]
var chosenUpgrades: Array[PackedScene]

func _ready() -> void:
  GM = Globals.getGameManager()
  BlankWrapper.name = "@NULL"
  BlankWrapper.texture = BlankSlot
  BlankWrapper.power = null
  GenerateNew()

# Could be done better
func _process(_delta) -> void:
  btn_proceed.disabled = !(slotsOccupied[0] && slotsOccupied[1])


func _selectPower(wrapper: PowerWrapper):
  for i in range(len(slotsOccupied)):
    if !slotsOccupied[i]:
      slotsOccupied[i] = true
      var btn_slot = slotsBtn[i]
      btn_slot.texture_normal = wrapper.texture

      chosenUpgrades[i] = wrapper.power

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

  GM.SetPowers(powerPassive, powerOnDeath)

func GenerateNew():
  toDisplay = GM.ChoosePowersToDisplay()
  print(" TO DISPLAY: ")
  for i in toDisplay: print(i.name)
  Populate()

func Populate():
  var box_displayedPowers = $VBoxContainer/availablePowers
  var box_selectedPowers = $VBoxContainer/selectedPowers

  # var btn_arr_displayed: Array[TextureButton] = box_displayedPowers.get_children().filter(func(el): el is TextureButton)
  # var btn_arr_selected: Array[TextureButton] = box_selectedPowers.get_children().filter(func(el): el is TextureButton)
  var btn_arr_displayed = box_displayedPowers.get_children()
  var btn_arr_selected = box_selectedPowers.get_children()
  

  slotsBtn.resize(2)
  slotsOccupied.resize(2)
  chosenUpgrades.resize(2)

  # Connect displayed powers' buttons
  for i in range(len(btn_arr_displayed)):
    if btn_arr_displayed[i] is TextureButton:
      var btn: TextureButton = btn_arr_displayed[i]
      btn.texture_normal = toDisplay[i].texture
      (btn.get_child(0) as RichTextLabel).text = "[center]" + toDisplay[i].name + "[/center]"

      var temp_callable = _selectPower.bind(toDisplay[i])

      btn.pressed.connect(temp_callable) # !TO FIX: When reshuffled, the bind doesn't change


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
