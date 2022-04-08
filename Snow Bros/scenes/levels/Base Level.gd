extends Node2D

export (PackedScene) var next_level:PackedScene

onready var enemies:Node2D = $Enemies

var n_children:int
var n_disabled_children:int

func _ready():
	n_children = enemies.get_child_count()

func _process(delta):
	n_disabled_children = 0
	for enemy in enemies.get_children():
		if enemy.disabled:
			n_disabled_children += 1
	if n_disabled_children == n_children:
		get_tree().change_scene_to(next_level)
