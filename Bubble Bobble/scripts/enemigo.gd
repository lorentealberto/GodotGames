extends RigidBody2D


const Velocidades: Dictionary = {
	SALTO = -85.0,
	HORIZONTAL = 40.0,
}


# VARIABLES SISTEMA
var _direccion: int = 0

func _ready() -> void:
	$AnimationPlayer.play("default")


"""Método propio de Godot para sobreescribir las velocidades de un objeto"""
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.linear_velocity.x = _direccion * Velocidades.HORIZONTAL


func _on_Timer_timeout():
	var pos_jugador: Vector2 = get_node("/root/Juego/Personaje").global_position.floor()
	
	var dist_x: float = floor(sqrt(pow(position.x - pos_jugador.x, 2)))
	if dist_x > 5:
		if floor(position.x) > pos_jugador.x:
			_direccion = -1
			$Sprite.flip_h = false
		elif floor(position.x) < pos_jugador.x:
			_direccion = 1
			$Sprite.flip_h = true
	
	if position.y > pos_jugador.y:
		var dist: float = floor(sqrt(pow(pos_jugador.y - global_position.y, 2)))
		if  (dist > 25 and dist <= 64) and $RayCast2D.is_colliding():
			apply_central_impulse(Vector2(0, Velocidades.SALTO))
