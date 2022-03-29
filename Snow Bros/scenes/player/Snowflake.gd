extends Area2D
class_name Snowflake
const FRICTION:float = 3.5

var hspeed:float = 150.0
var apply_gravity:bool

func _ready():
	apply_gravity = false

func _process(delta):
	position.x += hspeed * delta
	slowdown()
	
	if apply_gravity:
		position.y += Settings.WORLD_GRAVITY / 5 * delta

func relativity(parent_speed:float) -> void:
	hspeed += parent_speed

func set_direction(go_right:bool) -> void:
	$AnimatedSprite.flip_h = go_right
	if not go_right:
		hspeed *= -1

func slowdown() -> void:
	if hspeed > 0:
		hspeed -= FRICTION
	else:
		hspeed += FRICTION

func _on_Snowflake_body_entered(body):
	if body.name != "Player":
		if body is Enemy:
			queue_free()
			body.cover()
		else:
			queue_free()

func _on_Timer_timeout():
	apply_gravity = true

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
