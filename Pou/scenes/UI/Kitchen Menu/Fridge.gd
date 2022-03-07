extends Node

var content:Array

func _ready():
	randomize()
	fill()

func fill() -> void:
	var path:String = "res://scenes/UI/Kitchen Menu/graphics/foods/"
	var dir := Directory.new()
	
	# warning-ignore:return_value_discarded
	dir.open(path)
	# warning-ignore:return_value_discarded
	dir.list_dir_begin()
	
	while true:
		var file_name:String = dir.get_next()
		if file_name == "":
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
			content.append([load(path + file_name), randi() % 3 + 1])
	
	dir.list_dir_end()

func get_food_texture(id:int) -> Texture:
	if not content.empty():
		return content[id][0]
	return null

func get_food_quantity(id:int) -> int:
	if not content.empty():
		return content[id][1]
	return -1

func get_foods_available() -> int:
	if not content.empty():
		return len(content) - 1
	return -1
