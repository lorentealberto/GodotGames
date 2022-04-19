extends Node2D

export(PackedScene) var siguiente_nivel:PackedScene

func _ready():
	$Telon/AnimationPlayer.play("Abrir")
	
func _on_Telon_telon_cerrado():
	get_tree().change_scene_to(siguiente_nivel)


func _on_Meta_area_entered(area):
	if area.get_parent().name == "Jugador":
		$Telon/AnimationPlayer.play("Cerrar")

