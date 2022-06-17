extends Node2D

export(PackedScene) var siguiente_nivel:PackedScene

onready var telon:Sprite = $Telon
onready var telon_ap:AnimationPlayer = $Telon/AnimationPlayer

func _ready():
	telon.visible = true
	telon_ap.play("abrir")

func _on_Telon_telon_cerrado():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(siguiente_nivel)


func _on_Meta_area_entered(area):
	if area.name == "CuerpoJugador":
		var player: KinematicBody2D = area.get_parent() as KinematicBody2D
		player.set_collision_layer_bit(0, false)
		telon_ap.play("cerrar")
