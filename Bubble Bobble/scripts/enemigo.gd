extends RigidBody2D


const Velocidades: Dictionary = {
	SALTO = -85.0,
	HORIZONTAL = 40.0,
}


# VARIABLES SISTEMA
var _direccion: int = 0

func _ready() -> void:
	randomize()
	$AnimationPlayer.play("default")


"""Método propio de Godot para sobreescribir las velocidades de un objeto"""
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.linear_velocity.x = _direccion * Velocidades.HORIZONTAL


func _on_Timer_timeout():
	var pos_jugador: Vector2 = get_node("/root/Juego/Personaje").global_position
	
	var dist: float = floor(position.distance_to(pos_jugador))
	if dist < 64:
		if position.x > pos_jugador.x:
			_direccion = -1
			$Sprite.flip_h = false
		elif position.x < pos_jugador.x:
			_direccion = 1
			$Sprite.flip_h = true
	
		if floor(position.y) > floor(pos_jugador.y) and $RayCast2D.is_colliding():
			apply_central_impulse(Vector2(0, Velocidades.SALTO))
	else:
		match randi() % 3:
			0:
				_direccion = -1
				$Sprite.flip_h = false
			1:
				_direccion = 1
				$Sprite.flip_h = true
			2:
				if $RayCast2D.is_colliding():
					apply_central_impulse(Vector2(0, Velocidades.SALTO))
