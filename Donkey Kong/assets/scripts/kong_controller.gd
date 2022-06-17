extends Area2D

var pl_barril:PackedScene = preload("res://assets/prefabs/barril.tscn")

const RANGO_LANZAMIENTO:Vector2 = Vector2(3.0, 6.0)

func _ready() -> void:
	randomize()
	$Timer.start(rand_range(RANGO_LANZAMIENTO.x, RANGO_LANZAMIENTO.y))

func _on_Timer_timeout():
	$AnimatedSprite.play("cogiendo_barril")

func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		"cogiendo_barril":
			var instancia_barril:RigidBody2D = pl_barril.instance()
			get_parent().add_child(instancia_barril)
			instancia_barril.position = global_position
			$AnimatedSprite.play("enfadado")
		"enfadado":
			$Timer.start(rand_range(RANGO_LANZAMIENTO.x, RANGO_LANZAMIENTO.y))
			$AnimatedSprite.play("idle")
