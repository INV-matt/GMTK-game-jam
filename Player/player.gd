extends CharacterBody2D

# Added for code suggestions
class_name Player

@export_group("Movement")
@export var Speed = 300.0
@export var Acceleration = 30.0
@export var Deceleration = 30.0
@export var AccelerationPower = 0.9
@export var Dash = 1000

@export_group("Jump")
@export var JumpHeight = 96.0
@export var CoyoteTime = 5
@export var JumpBuffer = 5
@export var MaxJumps = 1
@export var FallGravityMultiplier = 1.5
@export var FastFallGravityMultiplier = 1.5
@export var GlobalGravityMult = 1
@export var GlobalGravityDir = 1

@export_group("Powers")
@export var ScaleMultiplier = 1.0
var _baseScale = Vector2(1.0, 1.0)
@export var BaseJumpModifier = 0
var _baseMaxJumps = 0
@export var SuperSpeedMultiplier = 1
var _baseSpeed = 0
var _baseAccel = 0

var _jumpCount = 0
var _lastOnFloor = 0.0
var _frameSinceJumpPressed = INF
var _localGravity = 980
var _direction
var _jumpVelocity = 0
var _isScouting = false
var _isClimbing = false

var movementLocked = false

@export var DoNotInterrupt = ["swing"]
var _animFinished = false

func _setAnimation(name: String):
  if $Sprite2D.animation in DoNotInterrupt and !_animFinished:
    return
  
  if $Sprite2D.animation == name:
    return
  
  _animFinished = false
  
  $Sprite2D.play(name)

func _prepare_on_next_level() -> void:
  movementLocked = false
  _isClimbing = false
  position = Vector2.ZERO

func _ready():
  _jumpVelocity = sqrt(2 * JumpHeight * _localGravity) # TODO: HARDCODED FOR NOW

  # TODO: Move this to after the player select their power
  _apply_powers_passive()
  
  _setAnimation("idle")
  
  BodyManager.connect("apply_powers", _apply_powers_ondeath)
  SignalBus.connect("next_level", _prepare_on_next_level)

  _baseScale = scale
  _baseMaxJumps = MaxJumps
  _baseSpeed = Speed
  _baseAccel = Acceleration

func _physics_process(delta: float) -> void:
  _frameSinceJumpPressed += 1
  
  up_direction = Vector2(0, -GlobalGravityDir)
  
  if GlobalGravityDir < 0:
    $Sprite2D.flip_v = true
  elif GlobalGravityDir > 0:
    $Sprite2D.flip_v = false
  
  if is_on_floor():
    _jumpCount = 0
    _lastOnFloor = 0
  
  if Input.is_action_just_pressed("pl_scout"): _handleScout()

  if !_isScouting && !movementLocked:
    _handleGravity(delta)
    _handleHorizontalMovement(delta)
    _handleJump()
    move_and_slide()

#region APPLY POWERS
func _apply_powers_passive():
  for i in get_children():
    # Only apply the powers of children of type "Power" and that have the group "power"
    if i is Power and "power" in i.get_groups():
      i.apply_power_passive()

func _apply_powers_ondeath():
  for i in get_children():
    # Only apply the powers of children of type "Power" and that have the group "power"
    if i is Power and "power" in i.get_groups():
      i.apply_power_death()
#endregion

#region HORIZONTAL MOVEMENT
func _handleHorizontalMovement(delta) -> void:
  # _direction = Input.get_axis("pl_left", "pl_right")
  # if _direction: # && !_isScouting:
  #   velocity.x = _direction * Speed
  # else:
  #   velocity.x = move_toward(velocity.x, 0, Deceleration)
  _direction = Input.get_axis("pl_left", "pl_right")
  
  if _direction < 0:
    $Sprite2D.flip_h = true
  elif _direction > 0:
    $Sprite2D.flip_h = false
    
  if is_on_floor() and !_isClimbing:
    if _direction:
      _setAnimation("walk")
    else:
      _setAnimation("idle")
  
  var target = _direction * Speed * SuperSpeedMultiplier
  var dv = target - velocity.x
  var accelRate = Acceleration if abs(dv) > 0.1 else Deceleration
  var mov = pow(abs(dv) * accelRate, AccelerationPower) * sign(dv)
  velocity.x += mov * delta
  print(mov)
  print(velocity.x)
#endregion

func _getCurrentGravity():
  return get_gravity() * GlobalGravityMult * GlobalGravityDir

#region GRAVITY
func _handleGravity(delta) -> void:
  if velocity.y > 0:
    if not is_on_floor() and !_isClimbing:
      _setAnimation("fall")
    _localGravity = _getCurrentGravity() * FallGravityMultiplier
  else:
    _localGravity = _getCurrentGravity()
    
    if velocity.y < 0 and !_isClimbing:
      _setAnimation("jump")

  if not is_on_floor():
    if Input.get_action_strength("pl_down"):
      velocity += _localGravity * FastFallGravityMultiplier * delta
    else:
      velocity += _localGravity * delta

    _lastOnFloor += 1
#endregion

#region JUMP
func _handleJump() -> void:
  if Input.is_action_just_pressed("pl_jump"): _frameSinceJumpPressed = 0

  if _frameSinceJumpPressed > JumpBuffer: return

  if is_on_floor():
    _jump()
    return

  if _lastOnFloor <= CoyoteTime && _jumpCount < 1:
    _jump()
    return

  if _jumpCount < MaxJumps && velocity.y >= 0 && _lastOnFloor > JumpBuffer:
    _jump()
    return
  
  if Input.is_action_just_released("pl_jump") && velocity.y < 0: velocity.y = 0 # Basic jump cutting


func _jump() -> void:
  _jumpCount += 1
  velocity.y = -_jumpVelocity
#endregion

#region SCOUT
func _handleScout() -> void:
  if _isScouting:
    _isScouting = false
    SignalBus.scout_exit.emit()
    return

  if !_isScouting:
    _isScouting = true
    SignalBus.scout_enter.emit()
#endregion

func _on_sprite_2d_animation_finished() -> void:
  _animFinished = true


# Calling with value = 1 is equal to resetting it
func SetScaleMultiplier(value: float) -> Vector2:
  ScaleMultiplier = value
  scale = _baseScale * ScaleMultiplier
  return scale

func IncreaseMaxJumps(amount: int) -> int:
  BaseJumpModifier = amount
  MaxJumps += amount
  return MaxJumps

func ResetMaxJumps():
  MaxJumps = _baseMaxJumps

# returns vector2(Speed, Accel)
# func SetSuperSpeedMultiplier(value: int) -> Vector2:
#   SuperSpeedMultiplier = value
#   Speed = _baseSpeed * SuperSpeedMultiplier
#   Acceleration = _baseAccel * SuperSpeedMultiplier
#   return Vector2(Speed, Acceleration)

func SetSuperSpeedMultiplier(value: int) -> void:
  SuperSpeedMultiplier = value