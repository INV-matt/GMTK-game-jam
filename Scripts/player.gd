extends CharacterBody2D

@export_group("Movement")
@export var Speed = 300.0
@export var Deceleration = 30.0
@export var Dash = 1000

@export_group("Jump")
@export var JumpHeight = 96.0
@export var CoyoteTimeSec = 0.2
@export var CoyoteTime = 5
@export var JumpBuffer = 5
@export var FallGravityMultiplier = 1.5
@export var FastFallGravityMultiplier = 1.5

var _jumpCount = 0
var _lastOnFloor = 0.0
var _frameSinceJumpPressed = INF
var _localGravity = 0
var _direction
var _hasDashed = false
var _jumpVelocity = 0

func _ready():
  _localGravity = get_gravity()
  _jumpVelocity = sqrt(2 * JumpHeight * 980) # TODO: HARDCODED FOR NOW
  print(_jumpVelocity)


func _physics_process(delta: float) -> void:
  _frameSinceJumpPressed += 1
  if is_on_floor():
    _jumpCount = 0
    _lastOnFloor = 0
    _hasDashed = false

  _handleGravity(delta)
  _handleHorizontalMovement()
  _handleJump()

  move_and_slide()


#region HORIZONTAL MOVEMENT
func _handleHorizontalMovement() -> void:
  _direction = Input.get_axis("pl_left", "pl_right")
  if _direction:
    velocity.x = _direction * Speed
  else:
    velocity.x = move_toward(velocity.x, 0, Deceleration)
#endregion

#region GRAVITY
func _handleGravity(delta) -> void:
  if velocity.y > 0:
    _localGravity = get_gravity() * FallGravityMultiplier
  else:
    _localGravity = get_gravity()

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


func _jump() -> void:
  _jumpCount += 1
  velocity.y = -_jumpVelocity
#endregion
