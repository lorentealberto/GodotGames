extends StaticBody2D
signal deleted

func _ready():
	if get_parent().name != "Game":
		# warning-ignore:return_value_discarded
		self.connect("deleted", get_parent(), "platform_deleted")

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("deleted")
	queue_free()

