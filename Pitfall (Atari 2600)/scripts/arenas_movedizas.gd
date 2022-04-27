extends Area2D

enum Estados { ABIERTO, CERRADO }
var estado_actual:int = Estados.ABIERTO

export(bool) var dinamico:bool

onready var tween:Tween = $Tween
onready var timer:Timer = $Timer

func _ready():
	add_to_group("obstaculos")
	if dinamico:
		timer.start()

func encogerse() -> void:
	tween.interpolate_property(self, "scale", scale, Vector2(0, 0), 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func agrandarse() -> void:
	tween.interpolate_property(self, "scale", scale, Vector2(1, 1), 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _on_Timer_timeout():
	match estado_actual:
		Estados.ABIERTO:
			encogerse()
			estado_actual = Estados.CERRADO
		Estados.CERRADO:
			agrandarse()
			estado_actual = Estados.ABIERTO
