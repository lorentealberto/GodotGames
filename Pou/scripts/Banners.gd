extends Control

signal open_fridge

func _on_Bottom_Banner_open_fridge():
	emit_signal("open_fridge")
