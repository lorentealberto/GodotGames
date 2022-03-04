extends Sprite

func _on_Body_area_entered(area):
	if area.name == "Food Body":
		if Status.hungry < 100:
			area.get_parent().get_parent().eat()
			Status.hungry += 25
