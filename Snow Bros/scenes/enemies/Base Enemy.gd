extends KinematicBody2D
class_name Enemy #Nombre de la clase

#Estados del objeto
enum States { COVERED, DEAD, DEFEATED, DOWN, IDLE, JUMP, ROLLING, SHAKING_SNOW, WALK }
var current_state = States.IDLE

#Nodos hijos del objeto
onready var animated_sprite:AnimatedSprite = $AnimatedSprite

#Velocidad del objeto
var velocity:Vector2

const KICKED_SPEED:float = 10000.0
var kicked:bool = false
var direction:String

"""Método que se ejecuta todos los frames del juego
	_delta: Tiempo en MS que ha transcurrido desde que se llamó a esta función por última vez"""
func _process(_delta):
	manage_animations()
	
"""Función que se llama todos los frames del juego
	_delta: Tiempo en MS que ha transcurrido desde que se llamó a esta función por última vez"""
func _physics_process(_delta):
	apply_gravity(_delta)
	manage_states()
	
	if kicked:
		velocity.x = 0
		if direction == "left":
			velocity.x -= KICKED_SPEED * _delta
		elif direction == "right":
			velocity.x += KICKED_SPEED * _delta
			
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

"""Gestiona los estados del objeto"""
func manage_states() -> void:
	if current_state != States.COVERED and current_state != States.ROLLING:
		if is_on_floor():
			current_state = States.IDLE

"""Gestiona la animación que se reproduce en base al estado del objeto"""
func manage_animations() -> void:
	match current_state:
		States.IDLE:
			animated_sprite.play("idle")
		States.COVERED:
			animated_sprite.animation = "covered"

"""Aplica gravedad al objeto
	delta: Tiempo en MS que ha transcurrido desde que se llamó a este método por última vez"""
func apply_gravity(delta:float) -> void:
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
	else:
		animated_sprite.frame += 1
		if animated_sprite.frame >= animated_sprite.frames.get_frame_count("covered") - 1:
			current_state = States.ROLLING

"""Devuelve true o false en función de si el objeto se encuentra en el estado rolling"""
func is_rolling() -> bool:
	return current_state == States.ROLLING

"""Evento que se dispara cada vez que se acaba de reproducir una animación"""
func _on_AnimatedSprite_animation_finished():
	pass
