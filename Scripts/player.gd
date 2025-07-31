extends CharacterBody2D

# Added for code suggestions
class_name Player

@export_group("Movement")
@export var Speed = 300.0
@export var Deceleration = 30.0
@export var Dash = 1000

@export_group("Jump")
@export var JumpHeight = 96.0
@export var CoyoteTime = 5
@export var JumpBuffer = 5
@export var MaxJumps = 1
@export var FallGravityMultiplier = 1.5
@export var FastFallGravityMultiplier = 1.5
@export var GlobalGravityMult = 1

var _jumpCount = 0
var _lastOnFloor = 0.0
var _frameSinceJumpPressed = INF
var _localGravity = 980
var _direction
var _jumpVelocity = 0

var movementLocked = false

func _ready():
  _jumpVelocity = sqrt(2 * JumpHeight * _localGravity) # TODO: HARDCODED FOR NOW

  # TODO: Move this to after the player select their power
  _apply_powers()

func _physics_process(delta: float) -> void:
  _frameSinceJumpPressed += 1
  
  if is_on_floor():
    _jumpCount = 0
    _lastOnFloor = 0

  if not movementLocked :
    _handleGravity(delta)
    _handleHorizontalMovement()
    _handleJump()

  move_and_slide()

#region APPLY POWERS
func _apply_powers() :
  for i in get_children() :
    # Only apply the powers of children of type "Power" and that have the group "power"
    if i is Power and "power" in i.get_groups() :
      i.apply_power_passive()
#endregion

#region HORIZONTAL MOVEMENT
func _handleHorizontalMovement() -> void:
  _direction = Input.get_axis("pl_left", "pl_right")
  if _direction:
    velocity.x = _direction * Speed
  else:
    velocity.x = move_toward(velocity.x, 0, Deceleration)
#endregion

func _getCurrentGravity() :
  return get_gravity() * GlobalGravityMult

#region GRAVITY
func _handleGravity(delta) -> void:
  if velocity.y > 0:
    _localGravity = _getCurrentGravity() * FallGravityMultiplier
  else:
    _localGravity = _getCurrentGravity()

  if not is_on_floor():
    if Input.get_action_strength("pl_down"):
      velocity += _localGravity * FastFallGravityMultiplier * delta
    else:
      velocity += _localGravity * delta

    _lastOnFloor += 1
#endregion

#region JUMP
func _handleJump() -> void:
  if Input.get_action_strength("pl_jump"): _frameSinceJumpPressed = 0

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


func _jump() -> void:
  _jumpCount += 1
  velocity.y = -_jumpVelocity
#endregion
