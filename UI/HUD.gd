extends CanvasLayer

@export var t_Lives: Array[TextureRect]

var GM: GameManager

func _ready() -> void:
  GM = Globals.getGameManager()
  UpdateLives()

func UpdateLives() -> void:
  #t_Lives.texture.region = Rect2(32 * GM.getLivesUsed(), 0, 32, 32)
  var digits = _separateDigits(GM.getLivesUsed())
  
  for i in range(len(digits)):
    t_Lives[i].texture.region = Rect2(32 * digits[i], 0, 32, 32)


func _separateDigits(value: int) -> Array:
  var str_val = str(value)
  # print(len(str_val))

  if len(str_val) == 1:
    return [0, value]

  return [int(str_val[0]), int(str_val[1])]
