extends KinematicBody2D

var velocity
var hspeed
var old_y

func _ready():
	velocity = Vector2.ZERO
	hspeed = 15000
	old_y = int(position.y)

func _physics_process(delta):
	velocity.x = 0
	velocity.y += 1500 * delta
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= hspeed * delta
		$Sprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x += hspeed * delta
		$Sprite.flip_h = false
	
	if is_on_floor():
		velocity.y -= 50000 * delta
		old_y = int(position.y)
		
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	if position.x < 0:
		position.x = get_viewport_rect().size.x
	elif position.x > get_viewport_rect().size.x:
		position.x = 0
