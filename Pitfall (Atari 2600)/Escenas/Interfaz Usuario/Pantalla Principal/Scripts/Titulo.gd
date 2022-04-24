extends TextureRect


onready var tween:Tween = $Tween

var valores_tween:Array = [0.0, 5.0]

func _ready():
	comenzar_tween()

func _process(delta):
	if Input.is_action_pressed("saltar") and not Configuracion.comenzar:
		$AnimationPlayer.play("desaparecer")
		get_parent().get_node("Label").visible = false
		Configuracion.comenzar = true

func comenzar_tween() -> void:
	tween.interpolate_property(self, "margin_left", valores_tween[0], valores_tween[1], 1.0)
	tween.start()

func _on_Tween_tween_completed(object, key):
	valores_tween.invert()
	comenzar_tween()
