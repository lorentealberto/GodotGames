extends Node2D

onready var timer = $Timer

var objects = []
	
func _ready():
	randomize()
	
	for obj in list_objects("res://scenes/objects/"):
		objects.append(load(obj))
	
func generate_obstacle():
	var rnd = randi() % objects.size()
	
	var obstacle = objects[randi() % objects.size()].instance()
	
	if obstacle.name == "Bird":
		obstacle.position.y -= 35
	
	obstacle.connect("body_entered", self, "reset")
	obstacle.position.y += rand_range(-5, 5)
	obstacle.set_script(load("res://scripts/Obstacle.gd"))
	
	add_child(obstacle)

func list_objects(path):
	var files = []
	var dir = Directory.new()
	
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file in ["Player.tscn", "Floor.tscn"]:
			files.append(path + file)
			
	dir.list_dir_end()
	
	return files
	
func reset(body):
	if body.name == "Player":
		get_tree().reload_current_scene()

func _on_Timer_timeout():
	generate_obstacle()
	timer.wait_time = rand_range(1.0, 1.5)

