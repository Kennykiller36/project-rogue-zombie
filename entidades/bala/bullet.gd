extends Node2D

const SPEED := 300
@export var dano: int

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("inimigo"):
		var inimigo = area.get_parent()
		inimigo.diminuir_vida(dano)
		queue_free()
