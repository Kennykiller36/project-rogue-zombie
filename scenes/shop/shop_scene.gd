extends CanvasLayer

@onready var container_itens = $Loja/ScrollContainer/VBoxContainer
@onready var rotulo_dinheiro = $Loja/CurrencyLabel
@onready var botao_sair = $Loja/BotaoSair

var shop_items: Array[ItemData] = [
	preload("res://entidades/items/consumiveis/medkit.tres"),
	preload("res://entidades/items/mod_de_arma/gatilho_leve.tres")
]

func _ready():
	if botao_sair:
		botao_sair.pressed.connect(_on_sair_pressionado)

func initialize(jogador):
	if jogador.dinheiro_atual == 0:
		jogador.dinheiro_atual = GameData.selected_player_data.dinheiroInicial
	atualizar_exibicao_dinheiro(jogador)
	popular_loja()

func popular_loja():
	for item in shop_items:
		var ui_item = preload("res://scenes/shop/item_ui.tscn").instantiate()
		container_itens.add_child(ui_item)
		ui_item.setup(item)
		ui_item.buy_pressed.connect(_on_comprar_pressionado)

func _on_comprar_pressionado(item: ItemData):
	var jogador = get_tree().get_first_node_in_group("player")
	if jogador and jogador.dinheiro_atual >= item.price:
		jogador.dinheiro_atual -= item.price
		aplicar_efeito_item(item, jogador)
		atualizar_exibicao_dinheiro(jogador)
	else:
		print("Dinheiro insuficiente")

func aplicar_efeito_item(item: ItemData, jogador: Player):
	if item.type == "Consumable":
		if item.effect_type == "heal":
			if jogador and jogador.has_method("aumentar_vida"):
				jogador.aumentar_vida(item.effect_value)
				print("Bought item: ", item.name)

	elif item.type == "WeaponMod":
		if not jogador.componente_arma:
			return

		var weapon = jogador.componente_arma
		if not weapon.weapon_data:
			return

		for att in weapon.weapon_data.attachments:
			if att == item:
				print("Already has this attachment: ", item.name)
				return

		weapon.weapon_data.attachments.append(item)

		if item.mod_stat == "fire_rate":
			var old_fire_rate = weapon.weapon_data.fire_rate
			weapon.weapon_data.fire_rate *= item.mod_value
			var new_fire_rate = weapon.weapon_data.fire_rate
			print("Bought attachment: ", item.name)
			print("Old fire rate: ", old_fire_rate, " | New fire rate: ", new_fire_rate)

		weapon.weapon_data_ready.emit()


func atualizar_exibicao_dinheiro(jogador: Player):
	if rotulo_dinheiro:
		rotulo_dinheiro.text = "Dinheiro: " + str(jogador.dinheiro_atual)
	else:
		push_error("rotulo_dinheiro is NULL – check node path")

func _on_sair_pressionado():
	queue_free() 
