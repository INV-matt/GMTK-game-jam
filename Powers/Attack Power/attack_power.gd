extends Power

@export var MaxCooldown = 30
@export var AtkDistance = 25
@export var AttackDuration = .25
@export var AtkDamage = 10

var isReady = false
var player: Player

var cooldown = 0

func _power_passive(p: Player):
  player = p

var damageArea = preload("res://Powers/Attack Power/damage_area.tscn")

func _power_death(p: Player):
  var area: Area2D = damageArea.instantiate()
  area.global_position = p.global_position
  
  get_tree().get_root().call_deferred("add_child", area)

var _aimDirection = 0

func _dealDamageToEnemy(enemy: Enemy):
  for i in enemy.get_children():
    if i is HealthComponent:
      i.doDamage(AtkDamage)

func _physics_process(delta: float) -> void:
  player = Globals.getPlayer()
  var dx = Input.get_axis("pl_left", "pl_right")
  
  if dx != 0:
    _aimDirection = dx
  
  if cooldown > 0:
    cooldown -= 1
    return
  
  if not Input.is_action_just_pressed("pl_attack"):
    return
  
  cooldown = MaxCooldown
  
  player._setAnimation("swing")
  
  var time = Timer.new()
  
  var damageArea = Area2D.new()
  var shape = CollisionShape2D.new()
  
  shape.shape = RectangleShape2D.new()
  shape.shape.size = Vector2(50, 40)
  
  damageArea.add_child(shape)
  damageArea.add_child(time)
  
  get_parent().add_child(damageArea)
  
  time.start(AttackDuration)
  time.connect("timeout", func(): damageArea.queue_free())
  
  damageArea.collision_layer = 0
  damageArea.collision_mask = 4 # Enemy is group 3 so 2^(3-1) = 4
  
  damageArea.connect("body_entered", func(x): _dealDamageToEnemy(x))
  
  damageArea.position = Vector2(_aimDirection * AtkDistance, 0)
