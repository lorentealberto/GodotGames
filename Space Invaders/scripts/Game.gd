extends Node

var plEnemy = preload("res://scenes/objects/Enemy.tscn")

var enemies = []

func _ready():
	spawn_enemies()

func _process(delta):
	if len(enemies) <= 0:
		get_tree().reload_current_scene()
	
func spawn_enemies():
	for i in range(5):
		for j in range(13):
			var enemy = plEnemy.instance()
			enemy.position = Vector2(100 + 70 * j, 70 + 50 * i)
			add_child(enemy)
			enemies.append(enemy)

