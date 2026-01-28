extends CharacterBody2D

@onready var area = $Area2D  # Assuming there's an Area2D child for collision detection

func _ready():
	if area:
		area.connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D):
	if area.is_in_group("player"):
		open_shop()

func open_shop():
	var jogador = get_tree().get_first_node_in_group("player")
	if jogador:
		if jogador.dinheiro_atual == 0:
			jogador.dinheiro_atual = GameData.selected_player_data.dinheiroInicial
		var shop_scene = preload("res://scenes/shop/loja.tscn").instantiate()
		get_tree().root.add_child(shop_scene)
		shop_scene.initialize(jogador)
