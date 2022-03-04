extends Control

onready var label = $HBoxContainer/Label




func _process(delta):
	label.text = get_parent().name


func _on_Go_Left_pressed():
	States.current_state -= 1
	States.change_scene()


func _on_Go_Right_pressed():
	States.current_state += 1
	States.change_scene()
