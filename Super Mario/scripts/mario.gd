extends CharacterBody2D

const HSPEED = 125
const GRAVITY = 40
const JFORCE = -550

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var fire_ball: PackedScene

var is_big = false
var  current_hspeed
var is_fire = false


func _ready():
	pass

func _physics_process(delta):
	_manage_animations()
	_apply_gravity()
	_controls()
	
	move_and_slide()

func _apply_gravity():
	velocity.y += GRAVITY

func _controls():
# SPRINT
	if Input.is_action_pressed("sprint"):
		current_hspeed = HSPEED * 1.5
	else:
		current_hspeed = HSPEED

# HORIZONTAL CONTROLS
	if Input.is_action_pressed("move_right"):
		animated_sprite_2d.flip_h = false
		velocity.x = current_hspeed
	elif Input.is_action_pressed("move_left"):
		animated_sprite_2d.flip_h = true
		velocity.x = -current_hspeed
	else:
		velocity.x = 0
# JUMP
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JFORCE
# DISPARAR
	if Input.is_action_just_pressed("shoot") and is_fire:
		_shoot()
	

func _manage_animations():
	if is_fire: #FLOR DE FUEGO
		if not is_on_floor():
			animated_sprite_2d.play("jump_fire")
		else:
			if velocity.x != 0:
				animated_sprite_2d.play("run_fire")
			else:
				animated_sprite_2d.play("idle_fire")
	elif is_big: # MARIO GRANDE
		if not is_on_floor():
			animated_sprite_2d.play("jump_big")
		else:
			if velocity.x != 0:
				animated_sprite_2d.play("run_big")
			else:
				animated_sprite_2d.play("idle_big")
	else: # MARIO PEQUEÑO
		if not is_on_floor():
			animated_sprite_2d.play("jump_small")
		else:
			if velocity.x != 0:
				animated_sprite_2d.play("run_small")
			else:
				animated_sprite_2d.play("idle_small")

func _shoot():
	var fire_ball_inst = fire_ball.instantiate()
	get_tree().root.call_deferred("add_child", fire_ball_inst)
	fire_ball_inst.global_position = global_position
	fire_ball_inst.set_dir(not animated_sprite_2d.flip_h)


func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("mushrooms"):
		is_big = true
		_swap_collisions()
		area.get_parent().call_deferred("queue_free")
	elif area.is_in_group("flowers"):
		is_fire = true
		is_big = true
		_swap_collisions()
		area.call_deferred("queue_free")

func _swap_collisions(set_small = false):
	$CollisionShape2D_small.call_deferred("set_disabled", not set_small)
	$CollisionShape2D_big.call_deferred("set_disabled", set_small)
	
