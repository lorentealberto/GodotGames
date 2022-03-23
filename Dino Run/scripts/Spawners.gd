extends Node

onready var _bird_spawner:Node2D = $BirdSpawner
onready var _obstacles_spawner:Node2D = $ObstaclesSpawner
onready var _timer:Timer = $Timer

var _objects:Array

func _ready():
	randomize()
	
	_objects = _load_scenes(_list_scenes())

func _generate_obstacle() -> void:
	var random_number:int = randi() % _objects.size()
	var obstacle:Obstacle = _objects[random_number].instance()
	
	# warning-ignore:return_value_discarded
	obstacle.connect("body_entered", self, "_reset")
	
	if obstacle.name == "Bird":
		obstacle.position = _bird_spawner.global_position
		
	else:
		obstacle.position = _obstacles_spawner.global_position
		add_child(obstacle)

func _load_scenes(scenes_path:Array) -> Array:
	var loaded_scenes:Array = []
	
	for scene_name in scenes_path:
		loaded_scenes.append(load(scene_name))
	
	return loaded_scenes
	
func _list_scenes() -> Array:
	var files:Array = []
	var dir:Directory = Directory.new()
	var path:String = "res://scenes/objects/obstacles/"
	
	# warning-ignore:return_value_discarded
	dir.open(path)
	# warning-ignore:return_value_discarded
	dir.list_dir_begin()
	
	while true:
		var file:String = dir.get_next()
		
		if file == "":
			break
		elif not file.begins_with(".") and file != "BaseObstacle.tscn":
			files.append(path + file)
			
	dir.list_dir_end()
	
	return files

func _reset(body:PhysicsBody2D) -> void:
	if body.name == "Dinosaur":
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()

func _on_Timer_timeout():
	_generate_obstacle()
	_timer.wait_time = rand_range(1.0, 1.5)


func _on_UI_start_game():
	_timer.start()
