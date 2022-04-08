extends KinematicBody2D

onready var animated_sprite:AnimatedSprite = $AnimatedSprite

onready var pl_minion:PackedScene = preload("res://scenes/enemies/bosses/Boss 1 Minion.tscn")

enum States { IDLE, JUMP, DEFEATED}
var current_state:int = States.IDLE

const JUMP_POWER:float = 12000.0 #Potencia de salto

var velocity:Vector2
var disabled:bool = false

var action:int = 0
func _physics_process(delta):
	randomize()
	
	apply_gravity(delta)
	
	match action:
		0:
			jump(delta)
		1:
			half_jump(delta)

	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	manage_states()
	manage_animations()

func apply_gravity(delta:float) -> void:
	if not is_on_floor():
		velocity.y += Settings.WORLD_GRAVITY * delta

func jump(delta:float) -> void:
	if is_on_floor():
		velocity.y -= JUMP_POWER * 1.5 * delta
		if !$MinionTimer.is_stopped():
			throw_minion(delta)

func throw_minion(delta:float) -> void:
	var minion_instance:Enemy = pl_minion.instance()
	get_parent().get_parent().add_child(minion_instance)

func half_jump(delta:float) -> void:
	if is_on_floor():
		velocity.y -= JUMP_POWER * delta

func manage_states() -> void:
	if is_on_floor():
			current_state = States.IDLE
	else:
		current_state = States.JUMP

func manage_animations() -> void:
	match current_state:
		States.IDLE:
			animated_sprite.play("idle")
		States.JUMP:
			animated_sprite.play("jump")

func _on_Timer_timeout():
	action = randi() % 2


func _on_MinionTimer_timeout():
	$MinionTimer.start()
