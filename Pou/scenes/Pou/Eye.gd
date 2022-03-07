extends Sprite

onready var pupil := $Pupil

func _physics_process(_delta):
	var mouse_position:Vector2 = get_viewport().get_mouse_position()
	pupil.look_at(mouse_position)
