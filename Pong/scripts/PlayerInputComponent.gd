extends Node
class_name PlayerInputComponent
"""Este comportamiento funciona exactamente igual que el controlador de la IA
	con la única diferencia de que en esta versión del comportamiento, se habilitan
	los controles para que el jugador pueda mover esta pala."""
var player:Paddle

func _ready():
	player = get_parent() #Se obtiene el nodo padre al que se le añade este componente
	# warning-ignore:return_value_discarded
	player.connect("update", self, "handle_input")
	
func handle_input():
	if not "direction" in player:
		return
	
	player.direction = Vector2()
	if Input.is_action_pressed("p1_up"):
		player.direction.y -= 1
	elif Input.is_action_pressed("p1_down"):
		player.direction.y += 1
