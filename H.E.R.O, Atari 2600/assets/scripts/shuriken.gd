extends Area2D

const VELOCIDAD:float = 100.0
var direccion:int

func _ready():
	if not $Sprite.flip_h:
		direccion = 1
	else:
		direccion = -1

func _physics_process(delta):
	position.x += direccion * VELOCIDAD * delta
	rotation_degrees += 20 * direccion

func flip_h(flip:bool) -> void:
	$Sprite.flip_h = flip

func _on_Shuriken_area_entered(area):
	if area.is_in_group("enemigos"):
		Global.puntuacion += 1000
		area.queue_free()
		queue_free()

func _on_Shuriken_body_entered(body):
	if body.name == "Muro" or body.name == "Suelo":
		queue_free()
