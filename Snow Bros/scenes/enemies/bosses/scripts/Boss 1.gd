extends KinematicBody2D

onready var animated_sprite:AnimatedSprite = $AnimatedSprite

onready var pl_minion:PackedScene = preload("res://scenes/enemies/bosses/Boss 1 Minion.tscn")


signal defeated

enum States { IDLE, JUMP, DEFEATED}
var current_state:int = States.IDLE

const JUMP_POWER:float = 12000.0 #Potencia de salto

var velocity:Vector2
var disabled:bool = false

var life:int = 25
var dead:bool = false

var action:int = 0

func _ready():
	randomize()

func _physics_process(delta):
	if life <= 0:
		dead = true
		emit_signal("defeated")
		current_state = States.DEFEATED
		$CollisionShape2D.shape = load("res://scenes/enemies/bosses/bodies/defeated.tres")
		for child in get_node("../../Minions").get_children():
			child.queue_free()
		
	apply_gravity(delta)
	
	if not dead:
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
			pass
			for i in range(randi() % 3 + 1):
				throw_minion(delta)

func throw_minion(delta:float) -> void:
	var minion_instance:Enemy = pl_minion.instance()
	minion_instance.position = position
	get_node("../../Minions").add_child(minion_instance)

func half_jump(delta:float) -> void:
	if is_on_floor():
		velocity.y -= JUMP_POWER * delta

func manage_states() -> void:
	if not dead:
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
		States.DEFEATED:
			animated_sprite.play("defeated")

func _on_Timer_timeout():
	action = randi() % 2


func _on_MinionTimer_timeout():
	$MinionTimer.start()


func _on_Area2D_area_entered(area):
	if not dead:
		if area.get_parent().name == "Player":
			get_tree().change_scene("res://scenes/levels/Floor 1.tscn")

		if area.name == "Snowflake":
			area.queue_free()
			life -= 1

		if area.get_parent() is Enemy:
			if area.get_parent().current_state == area.get_parent().States.ROLLING:
				area.get_parent().queue_free()
				life -= 5
