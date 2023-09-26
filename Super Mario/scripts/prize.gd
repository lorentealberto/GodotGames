extends StaticBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var prize:PackedScene

func _on_area_2d_area_entered(area):
	if animated_sprite_2d.animation != "empty":
		animated_sprite_2d.play("empty")
		_throw_object()



func _throw_object():
	var prize_inst = prize.instantiate()
	get_tree().root.call_deferred("add_child", prize_inst)
	prize_inst.global_position = global_position

