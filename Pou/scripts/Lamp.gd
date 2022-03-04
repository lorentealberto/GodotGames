extends TextureButton

onready var timer = $Timer

func _on_Lamp_button_down():
	timer.start()


func _on_Timer_timeout():
	if Status.tiredness <= 98:
		Status.tiredness += 2
