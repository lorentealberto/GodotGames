extends KinematicBody2D

#Obtenemos los nodos que tiene el jugador
onready var animated_sprite:AnimatedSprite = $AnimatedSprite
onready var raycast:RayCast2D = $RayCast2D

#Pre-cargamos los recursos necesarios
onready var pl_snowflake:PackedScene = preload("res://scenes/player/Snowflake.tscn") #Proyectil

#Definimos los estados del personaje
enum States { APPEARING, IDLE, JUMPING, PUSHING, SHOOTING, WALKING }
var current_state:int = States.APPEARING

#Constantes
const HSPEED:float = 15000.0
const JUMP_POWER:float = 38000.0

#Variables de movimiento
var velocity:Vector2

#Variable auxiliar de enemigo
var snowball:Enemy = null

func _process(_delta):
	manage_animations()

func _physics_process(delta):
	
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	if current_state != States.APPEARING:
		apply_gravity(delta)
		manage_states()
		push_snowball()
		controls(delta)

	position.x = clamp(position.x, 0, get_viewport_rect().size.x)

func apply_gravity(delta:float) -> void:
	velocity.y += Settings.WORLD_GRAVITY * delta

func controls(delta:float) -> void:
	horizontal_controls(delta)
	jump_controls(delta)
	shooting_controls()

func horizontal_controls(delta:float) -> void:
	velocity.x = 0
	if Input.is_action_pressed("left"):
		velocity.x -= HSPEED * delta
		look_at_right(false)
	elif Input.is_action_pressed("right"):
		velocity.x += HSPEED * delta
		look_at_right(true)

func look_at_right(flip:bool) -> void:
	#Voltear animación
	animated_sprite.flip_h = flip
	#Voltear raycast
	if flip:
		raycast.cast_to = Vector2(9, 0)
	else:
		raycast.cast_to = Vector2(-9, 0)

func jump_controls(delta:float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= JUMP_POWER * delta

func shooting_controls() -> void:
	if Input.is_action_just_pressed("shoot"):
		current_state = States.SHOOTING

func manage_states() -> void:
	if current_state != States.SHOOTING:
		if is_on_floor():
			current_state = States.IDLE
		
		if velocity.x != 0:
			current_state = States.WALKING
		
		if not is_on_floor():
			current_state = States.JUMPING

func manage_animations() -> void:
	match current_state:
		States.APPEARING:
			animated_sprite.play("appears")
		States.IDLE:
			animated_sprite.play("idle")
		States.WALKING:
			animated_sprite.play("walk")
		States.JUMPING:
			animated_sprite.play("jump")
		States.PUSHING:
			animated_sprite.play("push")
			if velocity.x == 0:
				animated_sprite.stop()
		States.SHOOTING:
			animated_sprite.play("shoot")

func throw_snowflake() -> void:
	var snowflake_instance:Snowflake = pl_snowflake.instance()
	snowflake_instance.position = position
	snowflake_instance.set_direction(animated_sprite.flip_h)
	snowflake_instance.relativity(velocity.x)
	get_parent().add_child(snowflake_instance)

func push_snowball() -> void:
	if raycast.is_colliding():
		if raycast.get_collider() is Enemy:
			snowball = raycast.get_collider()
			if snowball.is_rolling():
				current_state = States.PUSHING
				snowball.push(velocity.x)
	else:
		if snowball != null:
			snowball.drop()

func _on_AnimatedSprite_animation_finished():
	match animated_sprite.animation:
		"appears":
			current_state = States.IDLE
		"shoot":
			throw_snowflake()
			current_state = States.IDLE
