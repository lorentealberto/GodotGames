extends Node

#Se cargan los distintos nodos del juego.
onready var ball := $Ball
onready var paddles := [$Player, $AI]
onready var countdown_container := $HUD/CountdownContainer
onready var countdown := $HUD/CountdownContainer/CenterContainer/Countdown
onready var start_timer := $StartTimer
onready var player_score_label := $HUD/ScoreDisplay/PlayerScore
onready var ai_score_label := $HUD/ScoreDisplay/AIScore
onready var final_screen := $FinalScreen
onready var fs_result := $FinalScreen/VBoxContainer/ResultMsg

#Puntuación máxima de la partida.
const MAX_SCORE:int = 3
#Puntuación del jugador y de la IA.
var player_score:int
var ai_score:int

#Función que se ejcutará al cargar la escena.
func _ready():
	update_score()
	ai_score = 0
	player_score = 0
	start_timer.start() #Se empieza el reloj para iniciar la partida.

"""Método que se ejecutará todos los frames del juego."""
func _process(_delta):
	if start_timer.time_left > 1:
		countdown.set_text(str(round(start_timer.time_left)))


"""Método que controla si se ha marcado un gol en la porteria de la izquierda."""
func _on_Field_goal_left():
	ai_score += 1
	update_score()
	if ai_score < MAX_SCORE:
		start_new_round()
	else:
		show_winner("AI wins")

"""Método que controla si se ha marcado un gol en la porteria de la derecha."""
func _on_Field_goal_right():
	player_score += 1
	update_score()
	if player_score < MAX_SCORE:
		start_new_round()
	else:
		show_winner("You win")

"""Resetea todos los valores y las distintas posiciones para comenzar una nueva
partida."""
func start_new_round() -> void:
	countdown_container.set_visible(true)
	$StartTimer.start()
	ball.reset(true)
	for paddle in paddles:
		paddle.reset()

"""Actualiza la interaz de usuario para mostrar la puntuación de ambos jugadores."""
func update_score() -> void:
	ai_score_label.set_text(str(ai_score))
	player_score_label.set_text(str(player_score))

"""Método que se ejecuta cuando se ha acabado la cuenta atrás para iniciar una nueva ronda."""
func _on_StartTimer_timeout():
	countdown_container.set_visible(false)
	ball.reset(false)

"""Modifica la interfaz de usuario para mostrar quién ha ganado la partida.
params:
	message:string Mensaje que se mostrará en el HUD"""
func show_winner(message:String) -> void:
	final_screen.set_visible(true)
	fs_result.set_text(message)
	

"""Método que se ejcutará si el botón de finalizar partida ha sido pulsado."""
func _on_FinalScreen_exit():
	get_tree().quit()

"""Método que se ejecutará si el usuario ha pulsado el botón de comenzar una nueva
partida."""
func _on_FinalScreen_new_round():
	ai_score = 0
	player_score = 0
	ball.reset()
	update_score()
	final_screen.set_visible(false)
	start_new_round()
