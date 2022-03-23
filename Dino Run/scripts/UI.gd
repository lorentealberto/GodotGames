extends Control

signal start_game

onready var _score_label:Label = $ScoreLabel
onready var _start_game:Label = $StartGame

func _process(_delta):
	_score_label.text = str(get_parent().get_node("GoalLine").get_score())

func _input(event):
	if _start_game.visible:
		if event is InputEventKey and event.pressed:
			_start_game.hide()
			emit_signal("start_game")
