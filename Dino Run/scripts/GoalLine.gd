extends Area2D

var _score:int = 0

func _on_GoalLine_area_entered(area):
	if area is Obstacle:
		_score += 1

func get_score() -> int:
	return _score
