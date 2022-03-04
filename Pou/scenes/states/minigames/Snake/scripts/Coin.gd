extends Area2D

signal coin_taken

func _on_Coin_area_entered(area):
	if area.name == "Head":
		call_deferred("queue_free")
		emit_signal("coin_taken")
		Status.coins += 1
