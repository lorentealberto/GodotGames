extends Control

#Señal para empezar una nueva partida
signal new_round
#Señal para abandonar el juego
signal exit

"""Método se ejecuta cada vez que se pulsa el botón de comenzar
una nueva partida. Si el botón se pulsa, se emite la señal de empezar una nueva
partida."""
func _on_NewRoundBtn_pressed():
	emit_signal("new_round")

"""Método que se ejecuta cada vez que se pulsa el bóton de salir del juego. Si
se pulsa el botón, se emite la señal de salir del juego. """
func _on_ExitBtn_pressed():
	emit_signal("exit")
