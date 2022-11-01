extends Area2D

onready var pl_ladrillo: PackedScene = preload("res://objetos/ladrillo.tscn")

export var velocidad: float

var playback: AnimationNodeStateMachinePlayback


func _ready() -> void:
	playback = $AnimationTree.get("parameters/playback")
	randomize()
	$Timer.wait_time = floor(rand_range(2, 4))
	$Timer.start()
	


func _process(delta: float) -> void:
	position.x += velocidad * delta
	
	if velocidad > 0:
		$Sprite.flip_h = false
		if position.distance_to($Puntos/Position2D2.position) < 30:
			velocidad *= -1
	else:
		$Sprite.flip_h = true
		if position.distance_to($Puntos/Position2D.position) < 30:
			velocidad *= -1
	


func _on_Timer_timeout() -> void:
	$Timer.wait_time = floor(rand_range(2, 4))
	playback.travel("cabreado")
	for i in range(3):
		var ladrillo: Area2D = pl_ladrillo.instance()
		ladrillo.position = position
		get_parent().add_child(ladrillo)
		
		#Detiene el script un tiempo determinado
		var t = Timer.new()
		t.set_wait_time(0.25) #Tiempo que se detendrá el script
		add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
