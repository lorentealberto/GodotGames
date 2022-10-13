extends Area2D

const OBJETOS: Array = [0, 1, 3, 4, 6, 9]
const VHORIZONTAL: float = -100.0

func _ready() -> void:
	randomize()
	$Sprite.frame = OBJETOS[randi() % OBJETOS.size()]


func _process(delta: float) -> void:
	position.x += VHORIZONTAL * delta
