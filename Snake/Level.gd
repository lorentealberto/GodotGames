extends Node2D

onready var gear = preload("res://Apple.tscn")
var score = 0


func _ready():
	add_gear()

func _process(delta):
	$Score.text = "Points: " + (str(score))

func add_gear():
	var instance = gear.instance()
	instance.position = Vector2(rand_range(500, 50), rand_range(500, 50))
	instance.connect("Gear_used", self, "spawn_new")
	add_child(instance)

func spawn_new():
	add_gear()
	score += 5
	get_node("Snake").add_tail()
