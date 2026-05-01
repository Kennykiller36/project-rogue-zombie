extends CharacterBody2D

@onready var area := $Area2D
@onready var escolhas_dialog := $"../UIDialogo"
@onready var interact_prompt := $InteractPrompt

var player_in_range := false
var dialog_open := false
var effects: Array[Callable] = []

func _ready():
	if area:
		area.area_entered.connect(_on_area_entered)
		area.area_exited.connect(_on_area_exited)

	interact_prompt.visible = false


func _on_area_entered(other_area: Area2D):
	if other_area.is_in_group("player"):
		player_in_range = true
		interact_prompt.visible = true


func _on_area_exited(other_area: Area2D):
	if other_area.is_in_group("player"):
		player_in_range = false
		interact_prompt.visible = false


func _process(_delta):
	if player_in_range and not dialog_open and Input.is_action_just_pressed("interact"):
		dialogar()


func dialogar() -> void:
	if escolhas_dialog:
		dialog_open = true

		escolhas_dialog.escolhas = [
			"Me cure",
			"Me de dano",
			"Fechar"

		]

		effects = [
			increase_health,
			decrease_health,
			close_dialogue

		]

		escolhas_dialog.visible = true
		escolhas_dialog.SELECTED.connect(on_choice_selected)
	else:
		print("Error: UIDialogo node not found")


func on_choice_selected(index: int) -> void:
	if index < effects.size():
		effects[index].call()

	# close dialog state
	dialog_open = false
	escolhas_dialog.visible = false

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
		
func close_dialogue() -> void:
			dialog_open = false
