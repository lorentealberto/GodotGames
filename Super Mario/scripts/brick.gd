extends StaticBody2D


func _on_area_2d_area_entered(area):
	if area.get_parent().is_big:
		queue_free()
