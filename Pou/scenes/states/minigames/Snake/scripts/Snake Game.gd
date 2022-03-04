extends Node2D

onready var coin = preload("res://scenes/states/minigames/Snake/Coin.tscn")

func _ready():
	add_coin()

func add_coin():
	var instance = coin.instance()
	instance.position = Vector2(rand_range(320, 500), rand_range(320, 500))
	instance.connect("coin_taken", self, "spawn_new_coin")
	call_deferred("add_child", instance)

func spawn_new_coin():
	add_coin()
	$Snake.add_tail()
