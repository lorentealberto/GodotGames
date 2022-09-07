extends PathFollow

onready var pl_corazon := preload("res://objetos/corazon.tscn")

const SPEED: float = 2.0

func _ready() -> void:
	$Modelo/AnimationPlayer.get_animation("Walk").loop = true
	$Modelo/AnimationPlayer.play("Walk");

func _process(delta: float) -> void:
	set_offset(get_offset() + SPEED * delta)


func _on_Timer_timeout() -> void:
	var inst_corazon := pl_corazon.instance()
	inst_corazon.transform.origin = $SpawnPosition.global_transform.origin
	
	get_tree().get_root().add_child(inst_corazon)
