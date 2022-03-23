extends KinematicBody2D

onready var _normal_body:CollisionShape2D = $NormalBody
onready var _crouch_body:CollisionShape2D = $CrouchBody
onready var _animated_sprite:AnimatedSprite = $AnimatedSprite

var _velocity:Vector2
var _gravity_incremenet:float
var _jump_time:float

	
func _process(_delta):
	if Input.is_action_pressed("crouch"):
		_enable_crouch_body(true)
		
		if not is_on_floor():
			_gravity_incremenet = 7500.0
	else:
		_enable_crouch_body(false)
		_gravity_incremenet = 0.0

func _physics_process(delta):
	_velocity.x = 0
	_velocity.y += (Settings.WORLD_GRAVITY + _gravity_incremenet) * delta
	
	if Input.is_action_pressed("jump") and _jump_time < 0.04:
		_velocity.y -= Settings.DINOSAUR_JUMP_POWER * delta
		_jump_time += delta
	
	if is_on_floor():
		_jump_time = 0.0
	
	_velocity = move_and_slide_with_snap(_velocity, Vector2.DOWN, Vector2.UP)
	

func _enable_crouch_body(enable:bool) -> void:
	_crouch_body.disabled = enable
	_normal_body.disabled = !enable
	
	if enable:
		_animated_sprite.play("crouch")
	else:
		_animated_sprite.play("run")
