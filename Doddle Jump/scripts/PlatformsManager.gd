extends Node2D

export(NodePath) var camera_path
onready var camera = get_node(camera_path)

var plPlatform = preload("res://scenes/objects/Platform.tscn")
var vwpr
var platforms

func _ready():
	randomize()
	platforms = 0
	
	vwpr = get_viewport_rect().size.x
	set_up_initial_platforms()
	
func _process(_delta):
	if platforms < 15:
		generate_new_platforms()
	
func set_up_initial_platforms():
	for i in range(25):
		var platform = plPlatform.instance()
		platform.position.y += (75 * i) - 1000
		var rnd = rand_range(0, vwpr)
		platform.position.x = rnd
		add_child(platform)
		platforms += 1
		
func generate_new_platforms() -> void:
	for i in range(16):
		var platform = plPlatform.instance()
		platform.position.y += get_viewport_transform().affine_inverse().get_origin().y - (75 * i)
		var rnd = rand_range(0, vwpr)
		platform.position.x = rnd
		add_child(platform)
		platforms += 1

func platform_deleted():
	platforms -= 1
