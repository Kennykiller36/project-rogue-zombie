extends CharacterBody2D

@onready var area = $Area2D  # Assuming there's an Area2D child for collision detection
@onready var interact_prompt = $InteractPrompt

var player_in_range = false

func _ready():
	if area:
		area.connect("area_entered", Callable(self, "_on_area_entered"))
		area.connect("area_exited", Callable(self, "_on_area_exited"))


func _on_area_entered(area: Area2D):
	if area.is_in_group("player"):
		player_in_range=true
		interact_prompt.visible=true

func _on_area_2d_area_exited(area: Area2D) -> void:
		player_in_range=false
		interact_prompt.visible=false 


func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		open_shop()

func open_shop():
	var jogador = get_tree().get_first_node_in_group("player")
	if jogador:
		if jogador.dinheiro_atual == 0:
			jogador.dinheiro_atual = GameData.selected_player_data.dinheiroInicial
		var shop_scene = preload("res://scenes/shop/loja.tscn").instantiate()
		get_tree().root.add_child(shop_scene)
		shop_scene.initialize(jogador)
