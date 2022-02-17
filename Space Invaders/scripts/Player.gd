extends KinematicBody2D

onready var plBullet = preload("res://scenes/objects/Beam.tscn")


const SPEED = 250

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x -= SPEED * delta
	elif Input.is_action_pressed("ui_right"):
		position.x += SPEED * delta
		
	if Input.is_action_just_pressed("shoot"):
		var bullet = plBullet.instance()
		bullet.global_position = global_position
		get_parent().add_child(bullet)
