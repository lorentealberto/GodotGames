extends Sprite

signal telon_cerrado


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "cerrar":
		emit_signal("telon_cerrado")
