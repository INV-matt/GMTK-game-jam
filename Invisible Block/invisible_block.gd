extends StaticBody2D

@export var RevealRange = 75

@onready var sprite = $sprite
@onready var collision = $CollisionShape2D

func getAllNodes(node: Node) :
  var nodes: Array[Node] = node.get_children()
  
  for i in node.get_children() :
    nodes.append_array(getAllNodes(i))

  return nodes

var lights: Array[PointLight2D] = []

func LoadLights() :
  lights.clear()
  
  var root = get_tree().get_root()
  
  for i in getAllNodes(root) :
    if i is PointLight2D and "revealblocks" in i.get_groups() :
      lights.append(i)

func computeDistance() :
  var minDist: float = INF
  
  for i in lights :
    var dist = i.global_position.distance_squared_to(global_position)
    
    if not minDist or dist < minDist :
      minDist = dist
  
  return minDist

func calculateAlpha() :
  var dist = computeDistance()
  
  if dist == INF :
    return

  var fullReveal = pow(RevealRange, 2)
  var noReveal = pow(RevealRange * 2, 2)
  
  var t = clamp(dist, fullReveal, noReveal)
  var x = 1 - (t - fullReveal) / (noReveal - fullReveal)

  return x

func _process(delta: float) -> void:
  LoadLights()
  var alpha = calculateAlpha()
  
  # deactivate the collider & hide the sprite
  sprite.modulate.a = 0
  collision.debug_color = Color(1, 0, 0, .42)
  collision_layer = 0
  
  if not alpha :
    return
  
  # activate collision & set alpha for sprite
  sprite.modulate.a = alpha
  collision.debug_color = Color(0, 1, 0, .42)
  collision_layer = 1
