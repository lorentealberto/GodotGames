extends HBoxContainer

onready var icon := $Menu/Food
onready var label := $Menu/Food/Label


var food_id:int

func _ready():
	food_id = 0
	manage_food()

func _on_Left_arrow_pressed():
	food_id -= 1
	
	if food_id < 0:
		food_id = Fridge.get_foods_available()
		
	manage_food()
	

func _on_Right_arrow_pressed():
	food_id += 1
	
	if food_id > Fridge.get_foods_available():
		food_id = 0
	
	manage_food()

func manage_food() -> void:
	icon.texture = Fridge.get_food_texture(food_id)
	label.text = str(Fridge.get_food_quantity(food_id))
	
