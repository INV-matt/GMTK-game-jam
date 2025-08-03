extends CanvasLayer

@export var textures_Lives: Array[TextureRect]

@export var PowerContainer: Control
@export var textures_Powers: Array[TextureRect]

var GM: GameManager

func _ready() -> void:
  GM = Globals.getGameManager()
  UpdateLives()
  UpdatePowers()

func UpdateLives() -> void:
  #textures_Lives.texture.region = Rect2(32 * GM.getLivesUsed(), 0, 32, 32)
  var digits = _separateDigits(GM.getLivesUsed())
  
  for i in range(len(digits)):
    textures_Lives[i].texture.region = Rect2(32 * digits[i], 0, 32, 32)


func UpdatePowers() -> void:
  if !GM.CanShowPowers():
    PowerContainer.visible = false
    return
    
  PowerContainer.visible = true
  textures_Powers[0].texture = GM.ChosenPowers[0].texture # ERROR Null ChosenPower
  textures_Powers[1].texture = GM.ChosenPowers[1].texture


func _separateDigits(value: int) -> Array:
  var str_val = str(value)
  # print(len(str_val))

  if len(str_val) == 1:
    return [0, value]

  return [int(str_val[0]), int(str_val[1])]
