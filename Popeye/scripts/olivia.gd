extends Area2D

onready var pl_corazon := preload("res://objetos/corazon.tscn")

const VELOCIDAD:float = 25.0
var direccion:int

func _ready() -> void:
	direccion = 1

func _physics_process(delta: float) -> void:
	if direccion < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
		
	position.x += VELOCIDAD * direccion * delta

func _on_Olivia_area_entered(area: Area2D) -> void:
	if area.name == "Tejado":
		direccion *= -1


func _on_Timer_timeout() -> void:
	var instancia_corazon := pl_corazon.instance()
	get_parent().add_child(instancia_corazon)
	instancia_corazon.position = global_position
