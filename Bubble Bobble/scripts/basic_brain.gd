extends Node
class_name BasicBrain


@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var markers: Array = get_tree().get_nodes_in_group("marker")

var destiny: Marker2D = null

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:

		#Player position
		var player_x: int = round(player.global_position.x)
		var player_y: int = round(player.global_position.y)
		
		#Self position
		var self_x: int = round(owner.global_position.x)
		var self_y: int = round(owner.global_position.y)
		
		if player_y < self_y:
			owner.can_auto_jump = true
			if destiny == null or not owner.is_on_floor():
				destiny = markers[randi() % len(markers)]
			_go_to_destiny(self_x)
		elif player_y > self_y:
			#Dejarse caer
			owner.can_auto_jump = false
			pass
		else:
			owner.can_auto_jump = true
			#Perseguir jugador
			pass

func _go_to_destiny(self_x: int) -> void:
	var marker_x: int = round(destiny.global_position.x)
	
	if abs(self_x - marker_x) < 5:
		owner.direction = 0
		destiny = null
		owner._jump()
	else:
		if self_x > marker_x:
			owner.direction = -1
		elif self_x < marker_x:
			owner.direction = 1
