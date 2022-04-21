extends Area2D

enum Estados { ABIERTO, CERRADO }
var estado_actual:int = Estados.ABIERTO

export(bool) var dinamico:bool

func _ready():
	if dinamico:
		$Timer.start()

func encogerse() -> void:
	$Tween.interpolate_property(self, "scale", scale, Vector2(0, 0), 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func agrandarse() -> void:
	$Tween.interpolate_property(self, "scale", scale, Vector2(1, 1), 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func _on_Timer_timeout():
	match estado_actual:
		Estados.ABIERTO:
			encogerse()
			estado_actual = Estados.CERRADO
		Estados.CERRADO:
			agrandarse()
			estado_actual = Estados.ABIERTO
