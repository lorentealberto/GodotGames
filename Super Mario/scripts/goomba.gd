extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer


const GRAVITY = 10
const HSPEED = 25

var dir = 1

func _physics_process(delta):
	if animated_sprite_2d.animation != "die":
		_apply_gravity()
		
		_move()
		
		move_and_slide()


func _apply_gravity():
	velocity.y += GRAVITY


func _move():
	velocity.x = HSPEED * dir

func _on_area_2d_area_entered(area):
	if area.get_parent().name == "Mario":
		var mario = area.get_parent()
		if mario.velocity.y > 0:
			animated_sprite_2d.play("die")
			timer.start()
			
		else:
			mario.call_deferred("queue_free")



func _on_area_2d_body_entered(body):
	if body.is_in_group("pipes"):
		dir *= -1


func _on_timer_timeout():
	call_deferred("queue_free")
