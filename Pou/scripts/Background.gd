extends Control

onready var background_color = $"Background Color"

func change_color(color):
	background_color.color = color
