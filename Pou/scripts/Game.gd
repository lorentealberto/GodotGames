extends Node

onready var fridge = $Fridge

func _on_Banners_open_fridge():
	fridge.visible = true
