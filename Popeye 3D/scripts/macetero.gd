extends StaticBody

var activado: bool

func _ready() -> void:
	activado = false

func _process(delta: float) -> void:
	if activado:
		$Model.visible = true
	else:
		$Model.visible = false
