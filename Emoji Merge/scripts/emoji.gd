extends RigidBody2D
class_name Emoji

@export var merge_result: PackedScene
@export_range(1, 11) var emoji_id: int


@onready var window_size: Vector2 = get_viewport_rect().size
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_hitbox: CollisionShape2D = $HitBox/CollisionShape2D


var can_merge: bool = false
var body_disabled: bool = false

func _physics_process(delta: float) -> void:
	position.x = clamp(position.x, 0, window_size.x)


func _on_hit_box_area_entered(area: Area2D) -> void:
	if body_disabled or area.owner.body_disabled:
		return
	
	var collided_emoji: Emoji = area.owner
	if collided_emoji.can_merge:
		return
	
	can_merge = true
	
	if emoji_id == 11:
		delete_emojis(collided_emoji)
		return
	
	#En caso de que el método no se haya parado en ninguno de los puntos anteriores
	var instance: Emoji = merge_result.instantiate()
	instance.global_position = (global_position + collided_emoji.global_position) * 0.5
	instance.freeze = false
	get_tree().root.call_deferred("add_child", instance)
	delete_emojis(collided_emoji)
	
func delete_emojis(collided_emoji: Emoji) -> void:
	call_deferred("queue_free")
	collided_emoji.call_deferred("queue_free")

func set_disabled(new_state: bool) -> void:
	if collision_shape_2d == null:
		return
	collision_shape_2d.set_deferred("disabled", new_state)
	if collision_shape_2d_hitbox == null:
		return
	collision_shape_2d_hitbox.set_deferred("disabled", new_state)
