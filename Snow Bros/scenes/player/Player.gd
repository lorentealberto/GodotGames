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
const HSPEED:float = 6000.0 #Velocidad horizontal
const JUMP_POWER:float = 12000.0 #Potencia de salto

#Variables de movimiento
var velocity:Vector2

#Variable auxiliar de enemigo
var snowball:Enemy = null

"""Función que se ejecuta cada frame del juego
	_delta: Tiempo en MS desde que se llamó a esta función por última vez"""
func _process(_delta):
	manage_animations()

"""Función que se ejecuta todos los frames del juego de una manera estable.
	delta: Tiempo en MS desde que se llamó a esta función por última vez"""
func _physics_process(delta):
	#Actualiza la velocidad en base al KinematicBody
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	if current_state != States.APPEARING:
		apply_gravity(delta)
		manage_states()
		push_snowball()
		controls(delta)

	#Restringe la posición horizontal para que no pueda salir de la pantalla
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)

"""Aplica gravedad al vector de velocidad del objeto
	delta: Tiempo en MS desde que se llamó esta función por última vez"""
func apply_gravity(delta:float) -> void:
	velocity.y += Settings.WORLD_GRAVITY * delta

"""Habilita la detección de las pulsaciones del teclado
	delta: Tiempo en MS desde que se llamó esta función por última vez"""
func controls(delta:float) -> void:
	horizontal_controls(delta)
	jump_controls(delta)
	shooting_controls()

"""Gestiona los controles de movimiento horizontal
	delta: Tiempo en MS desde que se llamó esta función por última vez"""
func horizontal_controls(delta:float) -> void:
	velocity.x = 0
	if Input.is_action_pressed("left"):
		velocity.x -= HSPEED * delta
		look_at_right(false)
	elif Input.is_action_pressed("right"):
		velocity.x += HSPEED * delta
		look_at_right(true)

"""Voltea el sprite y el raycast en base al valor del parámetro flip
	flip: Si se volteará el sprite o el raycast o no"""
func look_at_right(flip:bool) -> void:
	#Voltear animación
	animated_sprite.flip_h = flip
	#Voltear raycast
	if flip:
		raycast.cast_to = Vector2(9, 0)
	else:
		raycast.cast_to = Vector2(-9, 0)

"""Gestiona los controles de salto
	delta: Tiempo en MS desde que se llamó esta función por última vez"""
func jump_controls(delta:float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= JUMP_POWER * delta

"""Gestiona los controles de disparo"""
func shooting_controls() -> void:
	if Input.is_action_just_pressed("shoot"):
		current_state = States.SHOOTING

"""Gestiona los estados del objetos"""
func manage_states() -> void:
	if current_state != States.SHOOTING: #Disparando
		if is_on_floor():
			current_state = States.IDLE #Parado
		
		if velocity.x != 0:
			current_state = States.WALKING #Andando
		
		if not is_on_floor():
			current_state = States.JUMPING #Saltando

"""Gestiona las animaciones del personaje en base al estado en el que esté el objeto. Las animaciones
		deben estar ordenadas según su prioridad, de menor a mayor."""
func manage_animations() -> void:
	match current_state:
		States.APPEARING: #Apareciendo
			animated_sprite.play("appears")
		States.IDLE: #Parado
			animated_sprite.play("idle")
		States.WALKING: #Andando
			animated_sprite.play("walk")
		States.JUMPING: #Saltando
			animated_sprite.play("jump")
		States.PUSHING: #Empujando una bola de nieve
			animated_sprite.play("push")
			if velocity.x == 0:
				animated_sprite.stop()
		States.SHOOTING: #Disparando
			animated_sprite.play("shoot")

"""Lanza un copo de nieve hacia la dirección a la que esté mirando el jugador"""
func throw_snowflake() -> void:
	var snowflake_instance:Snowflake = pl_snowflake.instance()
	snowflake_instance.position = position
	snowflake_instance.set_direction(animated_sprite.flip_h)
	snowflake_instance.relativity(velocity.x)
	get_parent().add_child(snowflake_instance)

"""Detecta si el jugador está chocando con alguna bola de nieve, si es así,
	la bola es empujada usando la velocidad actual del objeto"""
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

"""Evento que se lanza cada vez que una animación haya terminado de reproducirse"""
func _on_AnimatedSprite_animation_finished():
	match animated_sprite.animation:
		"appears":
			current_state = States.IDLE
		"shoot":
			throw_snowflake()
			current_state = States.IDLE
