extends Area2D

signal Gear_used

func _on_Apple_area_entered(area):
	if area.name == "Head":
		queue_free()
		emit_signal("Gear_used")
