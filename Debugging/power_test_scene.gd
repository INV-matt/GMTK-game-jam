extends Node2D

@export var powersToShow: Array[PackedScene] = []

func givePowerToPlayer(pow: Power, p: Player, shape: CollisionShape2D) :
  if shape.debug_color == Color(1, 0, 0, .42) :
    shape.debug_color = Color(0, 1, 0, .42)
  else :
    shape.debug_color = Color(1, 0, 0, .42)
  
  for i in p.get_children() :
    if pow.PowerName in i.get_groups() :
      p.remove_child(i)
      
      return
  
  pow.add_to_group(pow.PowerName)
  p.add_child(pow)
  pow.apply_power_passive()

func _ready() -> void:
  var px = 64
  
  for i in powersToShow :
    var pow: Power = i.instantiate()
    
    var area = Area2D.new()
    
    var shape = CollisionShape2D.new()
    shape.shape = RectangleShape2D.new()
    (shape.shape as RectangleShape2D).size = Vector2(50, 50)
    shape.debug_color = Color(1, 0, 0, .42)
    
    var text = RichTextLabel.new()
    text.text = pow.PowerName
    text.fit_content = true
    text.size = Vector2(500, 500)
    text.add_theme_font_size_override("normal_font_size", 9)
    text.position = Vector2(-25, -25)
    
    area.add_child(shape)
    area.add_child(text)
    
    area.position = Vector2(px, -60)
    area.collision_layer = 0
    area.collision_mask = 2
    area.connect("body_entered", func(x): givePowerToPlayer(pow, x, shape))
    
    add_child(area)
    
    px += 64
