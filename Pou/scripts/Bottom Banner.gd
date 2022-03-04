extends HBoxContainer

signal open_fridge


func _on_TextureButton_pressed():
	emit_signal("open_fridge")
