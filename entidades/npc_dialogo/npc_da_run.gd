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
	else:
		print("Error: UIDialogo node not found")
