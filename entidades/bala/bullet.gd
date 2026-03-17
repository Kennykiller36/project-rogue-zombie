extends Node2D

const SPEED := 300
@export var dano: int
var source_player: Node = null

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("inimigo"):
		var inimigo = area.get_parent()
		if inimigo and inimigo.has_method("diminuir_vida"):
			inimigo.diminuir_vida(dano, source_player)
		queue_free()
