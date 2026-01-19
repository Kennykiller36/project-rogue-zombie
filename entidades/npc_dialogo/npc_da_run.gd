extends CharacterBody2D

@onready var escolhas_dialog = $"../UIDialogo"

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		dialogar()

func dialogar() -> void:
	if escolhas_dialog:
		escolhas_dialog.escolhas = [
			"Do the thing",
			"Do the other thing"
		]
		escolhas_dialog.visible = true
		escolhas_dialog.SELECTED.connect(on_choice_selected)
	else:
		print("Error: UIDialogo node not found")

func on_choice_selected(index: int) -> void:
	var choice_text = escolhas_dialog.escolhas[index]
	print("Selected choice: ", choice_text)
