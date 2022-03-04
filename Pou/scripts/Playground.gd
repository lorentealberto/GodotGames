extends Node

onready var background = $Background

onready var minigames = ["res://scenes/states/minigames/Snake/Snake Game.tscn"]


func _ready():
	background.change_color("5ea959")


func _on_TextureButton_pressed():
	if not $"Game Selector/ItemList".get_selected_items().empty() and Status.tiredness >= 50:
		States.go_to(minigames[$"Game Selector/ItemList".get_selected_items()[0]])
		Status.tiredness -= 50
