extends CanvasLayer

@onready var container_itens = $Loja/ScrollContainer/VBoxContainer
@onready var rotulo_sucata = $Loja/CurrencyLabel
@onready var botao_sair = $Loja/BotaoSair

var craft_items: Array[ItemData] = [
	preload("res://entidades/items/consumiveis/medkit.tres"),
	preload("res://entidades/items/consumiveis/pente.tres")
]

var jogador: Player

func _ready():
	if botao_sair:
		botao_sair.pressed.connect(_on_sair_pressionado)

func initialize(p_jogador: Player):
	jogador = p_jogador
	atualizar_exibicao_sucata()
	popular_crafting()

func popular_crafting():
	for item in craft_items:
		var ui_item = preload("res://scenes/craft/item_ui_craft.tscn").instantiate()
		container_itens.add_child(ui_item)
		ui_item.setup(item)
		ui_item.craft_pressed.connect(_on_craft_pressionado)

func _on_craft_pressionado(item: ItemData):
	if jogador.sucata_atual >= item.craft_cost:
		jogador.sucata_atual -= item.craft_cost
		aplicar_efeito_item(item)
		atualizar_exibicao_sucata()
	else:
		print("Sucata insuficiente")

func aplicar_efeito_item(item: ItemData):
	if item is ConsumableData:
		item.apply(jogador)
		print("Crafted item: ", item.name)

	elif item is WeaponModData:
		if not jogador.componente_arma:
			return

		var weapon = jogador.componente_arma
		if not weapon.weapon_data:
			return

		if weapon.weapon_data.attachments.has(item):
			print("Already has this attachment: ", item.name)
			return

		weapon.weapon_data.attachments.append(item)
		item.apply_to_weapon(weapon.weapon_data)
		print("Crafted attachment: ", item.name)

		weapon.weapon_data_ready.emit()

func atualizar_exibicao_sucata():
	if rotulo_sucata:
		rotulo_sucata.text = "Sucata: " + str(jogador.sucata_atual)
	else:
		push_error("CurrencyLabel (Sucata) não encontrado")

func _on_sair_pressionado():
	queue_free()
