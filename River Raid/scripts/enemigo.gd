extends Area2D
class_name Enemigo


var activado: bool = false


func _ready() -> void:
	randomize()
	$AnimatedSprite.flip_h = randi() % 2 == 0


func _process(delta: float) -> void:
	if not activado:
		if (get_node("../../Avion") as KinematicBody2D).global_position.distance_to(global_position) < 20:
			activado = true
	else:
		pass

func destruir() -> void:
	$AnimatedSprite.visible = false
	$Sprite.visible = true
	$Timer.start()


func _on_Timer_timeout() -> void:
	queue_free()
