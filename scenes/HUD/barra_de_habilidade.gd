extends TextureProgressBar

var carga_habilidade = 0 : set = _set_carga_habilidade

func _set_carga_habilidade(nova_carga):
	var carga_anterior = carga_habilidade
	carga_habilidade = clamp(nova_carga, 0, max_value)
	value=carga_habilidade
	
func init_habilidade(_habilidade):
	carga_habilidade = _habilidade
	max_value = carga_habilidade
	value = carga_habilidade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
