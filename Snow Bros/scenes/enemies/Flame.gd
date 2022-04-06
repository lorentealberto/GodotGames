extends Area2D
class_name Flame

onready var sprite:Sprite = $Sprite
const HSPEED:float = 150.0 #Velocidad horizontal
var direction:String

func _physics_process(delta):
	match direction:
		"right":
			position.x += HSPEED * delta
			sprite.flip_h = true
		"left":
			position.x -= HSPEED * delta
			sprite.flip_h = false

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Flame_area_entered(area):
	if area.name != "Frog":
		queue_free()

func _on_Flame_body_entered(body):
	if body.name != "Frog":
		queue_free()
