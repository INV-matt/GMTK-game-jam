extends Control

var slotsFull: Array[bool] = []
var slotsBtn: Array[TextureButton] = []

@export var BlankSlot: CompressedTexture2D
@export var TextureToPower: Dictionary[CompressedTexture2D, PackedScene]

var TextureToPowername: Dictionary[CompressedTexture2D, String]

func _getPowerNameFromTexture(texture: CompressedTexture2D) :
  if texture in TextureToPowername :
    return TextureToPowername[texture]
  
  TextureToPowername[texture] = TextureToPower[texture].instantiate().PowerName

  return TextureToPowername[texture]

func _powerSelected(btn: TextureButton) :
  for i in range(len(slotsFull)) :
    if !slotsFull[i] :
      var slot = slotsBtn[i]
      
      slotsFull[i] = true
      slot.texture_normal = btn.texture_normal
      
      if i == 0 :
        (slot.get_child(0) as RichTextLabel).text = "[center]Active ability: " + _getPowerNameFromTexture(btn.texture_normal) + "[/center]"
      else :
        (slot.get_child(0) as RichTextLabel).text = "[center]On death ability: " + _getPowerNameFromTexture(btn.texture_normal) + "[/center]"
      
      return

func _powerUnselected(btn: TextureButton) :
  for i in range(len(slotsFull)) :
    if slotsBtn[i] == btn :
      slotsFull[i] = false
      
      btn.texture_normal = BlankSlot
      
      if i == 0 :
        (btn.get_child(0) as RichTextLabel).text = "[center]Active ability: None[/center]"
      else :
        (btn.get_child(0) as RichTextLabel).text = "[center]On death ability: None[/center]"
      
      return

func _ready() -> void:
  var availible = $VBoxContainer/availiblePowers
  var slots = $VBoxContainer/selectedPowers
  
  for i in availible.get_children() :
    if i is TextureButton :
      i.connect("pressed", _powerSelected.bind(i))
      (i.get_child(0) as RichTextLabel).text = "[center]" + _getPowerNameFromTexture(i.texture_normal) + "[/center]"
  
  for i in slots.get_children() :
    if i is TextureButton :
      i.connect("pressed", _powerUnselected.bind(i))
      
      i.texture_normal = BlankSlot
      
      slotsFull.push_back(false)
      slotsBtn.push_back(i)
  
  (slotsBtn[0].get_child(0) as RichTextLabel).text = "[center]Active ability: None[/center]"
  (slotsBtn[1].get_child(0) as RichTextLabel).text = "[center]On death ability: None[/center]"

func _on_select_powers_pressed() -> void:
  for i in slotsFull :
    if !i :
      print("Some slots empty")
      return

  var activePassive = slotsBtn[0]
  var activeOnDeath = slotsBtn[1]
  
  var powerPassive: Power = TextureToPower[activePassive.texture_normal].instantiate()
  var powerOnDeath: Power = TextureToPower[activeOnDeath.texture_normal].instantiate()

  powerPassive.OnDeathEnabled = false # Disable ondeath effect
  powerOnDeath.PassiveEnabled = false # Disable passive effect
  
  print(powerPassive)
  print(powerOnDeath)
