extends Area2D

#Inicializa el script
func _ready() -> void:
	$Ventana.frame = 1

#Modifica el frame de la ventana para dar la sensación de que ésta ha sido arreglada
func reparar() -> void:
	$Ventana.frame = 0
