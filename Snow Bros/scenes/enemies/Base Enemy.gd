extends KinematicBody2D
class_name Enemy #Nombre de la clase

#Estados del objeto
enum States { COVERED, DEAD, DEFEATED, DOWN, IDLE, JUMP, ROLLING, SHAKING_SNOW, WALK }
var current_state = States.IDLE

#Nodos hijos del objeto
onready var animated_sprite:AnimatedSprite = $AnimatedSprite

#Velocidad del objeto
var velocity:Vector2

const HSPEED:float = 3000.0
const KICKED_SPEED:float = 10000.0
const JUMP_POWER:float = 12000.0 #Potencia de salto
var kicked:bool = false
var direction:String
var SWIDTH:float
var disabled:bool = false

func _ready():
	SWIDTH = get_viewport_rect().size.x

"""Método que se ejecuta todos los frames del juego
	_delta: Tiempo en MS que ha transcurrido desde que se llamó a esta función por última vez"""
func _process(_delta):
	manage_animations()
	
"""Función que se llama todos los frames del juego
	_delta: Tiempo en MS que ha transcurrido desde que se llamó a esta función por última vez"""
func _physics_process(delta):
	apply_gravity(delta)
	manage_states()
	update_when_kicked(delta)
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

func jump(delta:float) -> void:
	if is_on_floor():
		velocity.y -= JUMP_POWER * delta

"""Actualiza la posición y la dirección a la que se dirige el objeto cuando éste
	es pateado
	delta: Tiempo en MS desde que se llamó a este método por última vez"""
func update_when_kicked(delta:float) -> void:
	if kicked:
		change_direction()
		velocity.x = 0
		move(delta)

func go_to(direction:String, delta:float) -> void:
	velocity.x = 0
	match direction:
		"left":
			velocity.x -= HSPEED * delta
		"right":
			velocity.x += HSPEED * delta

"""Mueve el objeto hacia la dirección indicada
	delta: Tiempo en MS desde es llamó a este método por última vez"""
func move(delta:float) -> void:
	if direction == "left":
		velocity.x -= KICKED_SPEED * delta
	elif direction == "right":
		velocity.x += KICKED_SPEED * delta

"""Cambia la dirección hacia la que acelera el objeto si éste choca con los
	bordes de la pantalla"""
func change_direction() -> void:
		if position.x <= 0:
			direction = "right"
		elif position.x >= SWIDTH:
			direction = "left"

"""Gestiona los estados del objeto"""
func manage_states() -> void:
	if current_state != States.COVERED and current_state != States.ROLLING and current_state != States.DEFEATED:
		if is_on_floor():
			current_state = States.IDLE
		
		if velocity.x != 0:
			current_state = States.WALK
		
		if not is_on_floor():
			current_state = States.JUMP

"""Gestiona la animación que se reproduce en base al estado del objeto"""
func manage_animations() -> void:
	#Manage direction
	if velocity.x > 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	match current_state:
		States.IDLE:
			animated_sprite.play("idle")
		States.WALK:
			animated_sprite.play("walk")
			
		States.JUMP:
			animated_sprite.play("jump")
		States.COVERED:
			animated_sprite.animation = "covered"
		States.DEFEATED:
			animated_sprite.play("defeated")

"""Aplica gravedad al objeto
	delta: Tiempo en MS que ha transcurrido desde que se llamó a este método por última vez"""
func apply_gravity(delta:float) -> void:
	if not is_on_floor():
		velocity.y += Settings.WORLD_GRAVITY * delta

"""Aplica una fuerza de empuje al objeto
	vel: Fuerza de empuje que se aplicará a este objeto"""
func push(vel:float) -> void:
	if not kicked:
		velocity.x = vel

"""El objeto ya no se moverá a la misma velocidad que el objeto que le esté
	empujando"""
func drop() -> void:
	if not kicked:
		velocity.x = 0

"""Acelera el objeto en la dirección indicada por parámetro
	flip_h: Dirección hacía la que se acelerará el objeto"""
func kick(flip_h:bool) -> void:
	animated_sprite.play("rolling")
	kicked = true
	#Marcar dirección
	if flip_h:
		direction = "right"
	else:
		direction = "left"

"""Cambia el estado y la animación del objeto dependiendo del estado actual"""
func cover() -> void:
	if current_state != States.COVERED and current_state != States.ROLLING:
		current_state = States.COVERED
		animated_sprite.stop()
		animated_sprite.frame = 0
		velocity.x = 0
	else:
		animated_sprite.frame += 1
		if animated_sprite.frame >= animated_sprite.frames.get_frame_count("covered") - 1:
			current_state = States.ROLLING

"""Devuelve true o false en función de si el objeto se encuentra en el estado rolling"""
func is_rolling() -> bool:
	return current_state == States.ROLLING

func disable() -> void:
	position.x = -100
	set_process(false)
	set_physics_process(false)
	disabled = true

"""Evento que se dispara cada vez que se acaba de reproducir una animación"""
func _on_AnimatedSprite_animation_finished():
	if animated_sprite.animation == "defeated":
		queue_free()

func _on_Area2D_area_entered(area):
	if is_rolling() and velocity.x != 0:
		if area.name == "EBody":
			if area.get_parent().current_state == States.ROLLING:
				area.get_parent().kick(animated_sprite.flip_h)
			else:
				area.get_parent().current_state = States.DEFEATED
				area.get_parent().get_node("CollisionShape2D").set_deferred("disabled", true)
		elif area.name == "DeadZone":
			disable()

func _on_VisibilityNotifier2D_screen_exited():
	disable()
