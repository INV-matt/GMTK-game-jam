extends Control

var slotsFull: Array[bool] = []
var slotsBtn: Array[TextureButton] = []

@export var BlankSlot: CompressedTexture2D

func _powerSelected(btn: TextureButton) :
  for i in range(len(slotsFull)) :
    if !slotsFull[i] :
      var slot = slotsBtn[i]
      
      slotsFull[i] = true
      slot.texture_normal = btn.texture_normal
      
      return

func _powerUnselected(btn: TextureButton) :
  for i in range(len(slotsFull)) :
    if slotsBtn[i] == btn :
      slotsFull[i] = false
      
      btn.texture_normal = BlankSlot
      
      return

func _ready() -> void:
  var availible = $VBoxContainer/availiblePowers
  var slots = $VBoxContainer/selectedPowers
  
  for i in availible.get_children() :
    if i is TextureButton :
      i.connect("pressed", _powerSelected.bind(i))
  
  for i in slots.get_children() :
    if i is TextureButton :
      i.connect("pressed", _powerUnselected.bind(i))
      
      i.texture_normal = BlankSlot
      
      slotsFull.push_back(false)
      slotsBtn.push_back(i)
