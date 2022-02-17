extends Area2D

onready var animated_sprite = $AnimatedSprite
onready var timer = $Timer
onready var collisions = $CollisionShape2D

func _on_Enemy_area_entered(area):
	if "Beam" in area.name:
		area.queue_free()
		animated_sprite.animation = "dead"
		timer.start()
		collisions.set_deferred("disabled", true)


func _on_Timer_timeout():
	get_parent().enemies.erase(self)
	queue_free()
	
