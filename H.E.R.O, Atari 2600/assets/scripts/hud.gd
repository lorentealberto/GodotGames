extends Control

onready var pl_bombas_hud := preload("res://assets/prefabs/icono_bomba.tscn")
onready var pl_vidas_hud := preload("res://assets/prefabs/icono_vida.tscn")

onready var potencia := $CanvasLayer/Panel/VBoxContainer/Potencia/ProgressBar
onready var vidas := $CanvasLayer/Panel/VBoxContainer/Vidas
onready var bombas := $CanvasLayer/Panel/VBoxContainer/Bombas

func _ready():
	actualizar_bombas()
	actualizar_vidas()

func _process(_delta):
	potencia.value = Global.potencia
	$CanvasLayer/Panel/VBoxContainer/Puntuacion.text = "%06d" % (Global.puntuacion)

func _on_Jugador_bomba_puesta():
	actualizar_bombas()
func actualizar_bombas() -> void:
	for child in bombas.get_children():
		bombas.remove_child(child)
	for _i in range(Global.bombas):
		bombas.add_child(pl_bombas_hud.instance())

func _on_Jugador_vida_perdida():
	actualizar_vidas()
func actualizar_vidas() -> void:
	for child in vidas.get_children():
		vidas.remove_child(child)
	for _i in range(Global.vidas):
		vidas.add_child(pl_vidas_hud.instance())
