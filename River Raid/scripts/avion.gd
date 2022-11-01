extends KinematicBody2D

export var misil: PackedScene
export var velocidad_movimiento: float


var direccion: int

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("mover_derecha"):
		direccion = 1
		$Sprite.frame = 0
	elif Input.is_action_pressed("mover_izquierda"):
		direccion = -1
		$Sprite.frame = 2
	else:
		direccion = 0
		$Sprite.frame = 1
	
	if $Sprite.visible:
		move_and_slide(Vector2(direccion * velocidad_movimiento, 0), Vector2.UP)
	
	if Input.is_action_just_pressed("disparar"):
		var instancia_misil: Area2D = misil.instance()
		get_parent().add_child(instancia_misil)
		instancia_misil.position = position
	

func _on_Area2D_area_entered(area):
	if area.name == "Fondo":
		$Sprite.visible = false
		$Explosion.visible = true
