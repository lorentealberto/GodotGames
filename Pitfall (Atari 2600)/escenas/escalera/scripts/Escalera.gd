extends Area2D

func _on_Gatillo_area_entered(area):
	if area.name == "Cuerpo":
		area.get_parent().escalando = true

func _on_Escalera_area_exited(area):
	if area.name == "Cuerpo":
		area.get_parent().escalando = false
