extends TextureRect

onready var tween:Tween = $Tween
onready var animation_player:AnimationPlayer = $AnimationPlayer

var valores_tween:Array = [3.0, 8.0]

func _ready():
	comenzar_tween()

func _process(_delta):
	if Input.is_action_pressed("saltar") and not Configuracion.comenzar:
		animation_player.play("desaparecer")
		get_parent().get_node("Label").visible = false
		Configuracion.comenzar = true

func comenzar_tween() -> void:
# warning-ignore:return_value_discarded
	tween.interpolate_property(self, "margin_left", valores_tween[0], valores_tween[1], 1.0)
# warning-ignore:return_value_discarded
	tween.start()

func _on_Tween_tween_completed(_object, _key):
	valores_tween.invert()
	comenzar_tween()
