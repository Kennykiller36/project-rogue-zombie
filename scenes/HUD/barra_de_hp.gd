extends ProgressBar

@onready var timer = get_node_or_null("Timer")
@onready var barra_dano = get_node_or_null("BarraDeDano")

var hp = 0 : set = _set_hp

func _set_hp(novo_hp):
	var hp_anterior = hp
	hp = clamp(novo_hp, 0, max_value)
	value = hp
	if hp <= 0:
		queue_free()
	# quando toma dano
	if hp < hp_anterior:
		if timer:
			timer.start()
		else:
			print("Warning: BarraDeHp: Timer node not found")
	# quando recebe vida
	else:
		if barra_dano:
			barra_dano.value = hp
		else:
			print("Warning: BarraDeHp: BarraDeDano node not found")


func init_health(_health):
	hp = _health
	max_value = hp
	value = hp
	if barra_dano:
		barra_dano.max_value = hp
		barra_dano.value = hp
	else:
		print("Warning: BarraDeHp: BarraDeDano node not found on init")


func _on_timer_timeout() -> void:
	if barra_dano:
		barra_dano.value = hp
	else:
		print("Warning: BarraDeHp: BarraDeDano node not found on timer timeout")
