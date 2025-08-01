extends Area2D

@export var Damage = 5

func _dealDamageToEnemy(enemy: Enemy) :
  for i in enemy.get_children() :
    if i is HealthComponent :
      i.doDamage(Damage)
      
func _on_timer_timeout() -> void:
  for i in get_overlapping_bodies() :
    _dealDamageToEnemy(i)
