extends Control

@onready var weapon_sprite: Sprite2D = $Sprite2D
@onready var ammo_label: Label = $Label

var arma: Node2D


func _ready() -> void:
	find_arma()
	connect_signals()


func find_arma() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if not player:
		push_warning("Player não encontrado")
		return

	arma = player.get_node_or_null("arma")
	if not arma:
		push_warning("Arma não encontrada")


func connect_signals() -> void:
	if not arma:
		return

	if not arma.weapon_data_ready.is_connected(_on_weapon_data_ready):
		arma.weapon_data_ready.connect(_on_weapon_data_ready)

	if not arma.shot.is_connected(_on_arma_shot):
		arma.shot.connect(_on_arma_shot)


func update_display() -> void:
	if not arma or not arma.weapon_data:
		return

	var data: WeaponData = arma.weapon_data

	weapon_sprite.texture = data.gun_texture if data.gun_texture else null

	if data.infinite_ammo:
		ammo_label.text = "∞"
	else:
		ammo_label.text = str(arma.municao_atual)


##Signals
func _on_weapon_data_ready() -> void:
	update_display()


func _on_arma_shot() -> void:
	update_display()
