extends CharacterBody2D

@onready var escolhas_dialog = $"../UIDialogo"

var effects: Array[Callable] = []

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		dialogar()

func dialogar() -> void:
	if escolhas_dialog:
		escolhas_dialog.escolhas = [
			"Me cure",
			"Me de dano"
		]
		effects = [
			increase_health,
			decrease_health
		]
		escolhas_dialog.visible = true
		escolhas_dialog.SELECTED.connect(on_choice_selected)
	else:
		print("Error: UIDialogo node not found")

func on_choice_selected(index: int) -> void:
	if index < effects.size():
		effects[index].call()
	escolhas_dialog.SELECTED.disconnect(on_choice_selected)

func increase_health() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("aumentar_vida"):
		player.aumentar_vida()
		print("Player health increased")

func decrease_health() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("diminuir_vida"):
		player.diminuir_vida(10)
		print("Player health decreased")
