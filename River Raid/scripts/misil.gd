extends Area2D

export var velocidad: float

func _process(delta: float) -> void:
	position.y -= velocidad * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Misil_area_entered(area):
	if area is Enemigo:
		area.destruir()
		queue_free()
