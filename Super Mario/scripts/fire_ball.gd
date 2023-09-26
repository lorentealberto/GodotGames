extends CharacterBody2D


const GRAVITY = 1
const JFORCE = 8
const HSPEED = 5

var dir

func _physics_process(delta):
	_apply_gravity()
	
	
	velocity.x = HSPEED * dir
	if move_and_collide(velocity):
		_jump()

func _apply_gravity():
	velocity.y += GRAVITY

func _jump():
	velocity.y = -JFORCE
	
func set_dir(dir):
	if dir:
		self.dir = 1
	else:
		self.dir = -1
	
func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("pipes"):
		call_deferred("queue_free")
