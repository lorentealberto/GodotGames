extends Node2D


@export var emojis: Array[PackedScene]

var empty: bool = true
var reference: Emoji

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	if empty:
		reference = get_random_emoji()
		return
	
	if reference == null:
		return
	

	reference.global_position = get_global_mouse_position()
	reference.global_position.y = 50
	if Input.is_action_just_pressed("drop_emoji"):
		empty = true
		reference.set_disabled(false)
		reference.freeze = false
		reference = null


func get_random_emoji() -> Emoji:
	var instance: Emoji = emojis[randi() % emojis.size()].instantiate()
	instance.global_position = get_global_mouse_position()
	instance.global_position.y = 50
	get_tree().root.add_child(instance)
	instance.set_disabled(true)
	empty = false
	return instance
