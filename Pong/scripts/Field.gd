extends Node2D

#Señal para los goles de la portería de la derecha
signal goal_right
#Señal para los goles de la portería izquierda
signal goal_left

"""Este método se ejecuta si algún objeto entra en el área de la porteria derecha.
Cada vez que entra un objeto, se emite la señal de gol."""
func _on_GoalRight_body_entered(_body):
	emit_signal("goal_right")

"""Este método se ejecuta si algún objeto entra en el área de la porteria izquierda.
Cada vez que entra un objeto, se emite la señal de gol."""
func _on_GoalLeft_body_entered(_body):
	emit_signal("goal_left")
