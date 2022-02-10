extends Node

onready var br = preload("res://scenes/objects/Brick.tscn")

onready var player = $Player

var is_dragging = false
var touchpos = Vector2()

func _ready():
	set_bricks()
	
func set_bricks():
	var numbricks = 0
	
	for i in range(3):
		for j in range(13):
			var brick = br.instance()
			brick.position = Vector2(100 + 70 * j, 70 + 50 * i)
			numbricks += 1
			add_child(brick)

func _input(event):
	if event is InputEventMouseButton:
		if event.position.y > 80:
			if event.is_pressed():
				is_dragging = true
			elif not event.is_pressed():
				is_dragging = false
				player.move_to(event.position)
	if event.position.y > 80:
		if is_dragging:
			touchpos = event.position

func _physics_process(delta):
	if is_dragging:
		player.drag_to(touchpos)
