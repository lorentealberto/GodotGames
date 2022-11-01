extends Area2D

export var velocidad: float

func _ready():
	randomize()
	$Sprite.frame = randi() % $Sprite.hframes


func _process(delta: float) -> void:
	position.y += velocidad * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_area_entered(area: Area2D):
	if area.get_parent().name == "Felix":
		area.get_parent().queue_free()
		queue_free()
