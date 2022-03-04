extends Control

onready var item_list = $ItemList

func _process(delta):
	if FridgeContent.food_available != []:
		var i = 0
		for food in FridgeContent.food_available:
			var item_txt = "UHave " + str(food[1]) + " - Price: " + str(food[2]) + " coins"
			item_list.set_item_text(i, item_txt)
			i += 1

func _on_TextureButton_pressed():
	visible = false


func _on_BuyBtn_pressed():
	var item_selected = item_list.get_selected_items()
	var item_price = FridgeContent.food_available[item_selected[0]][2]
	if Status.coins >= item_price and FridgeContent.food_available[item_selected[0]][1] < 10:
		Status.coins -= item_price
		FridgeContent.food_available[item_selected[0]][1] += 1
		
