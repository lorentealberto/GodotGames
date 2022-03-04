extends HBoxContainer

onready var plFood = preload("res://scenes/objects/Food.tscn")
onready var FS_node = $"Food Selected"
onready var quantity = $"Food Selected/Quantity"

var food_selected = 0
var food_clicked = false
var food_instance

func _ready():
	if FridgeContent.food_available == []:
		load_all_foods()
	food_instance = plFood.instance()
	add_child(food_instance)

func load_all_foods():
	var path = "res://assets/graphics/objects/foods/"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
			FridgeContent.food_available.append([load(path + file_name), randi() % 3 + 1, randi() % 20 + 1])
	dir.list_dir_end()

func _process(delta):
	select_food()
	drag_food()
	manage_texture()

func select_food():
	if food_selected < 0:
		food_selected = len(FridgeContent.food_available) - 1
	elif food_selected > len(FridgeContent.food_available) - 1:
		food_selected = 0

func drag_food():
	if food_clicked:
		food_instance.visible = true
		FS_node.visible = false
		food_instance.position = get_local_mouse_position()
	elif not food_clicked:
		food_instance.visible = false
		if len(FridgeContent.food_available) > 0:
			FS_node.visible = true

func manage_texture():
	if len(FridgeContent.food_available) > 0:
		FS_node.texture = FridgeContent.food_available[food_selected][0]
		quantity.text = str(FridgeContent.food_available[food_selected][1])
		food_instance.set_texture(FridgeContent.food_available[food_selected][0])

	
func eat():
	if FridgeContent.food_available[food_selected][1] > 0:
		FridgeContent.food_available[food_selected][1] -= 1
		
	food_clicked = false
	
func _on_Right_Button_pressed():
	food_selected += 1

func _on_Left_Button_pressed():
	food_selected -= 1

func _on_Food_Selected_gui_input(event):
	if event.is_action_pressed("left_click") and FridgeContent.food_available[food_selected][1] > 0:
		food_clicked = true
		
func _input(event):
	if event.is_action_released("left_click"):
		food_clicked = false
