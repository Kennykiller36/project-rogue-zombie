extends Control

@onready var weapon_sprite: Sprite2D = $Sprite2D
@onready var ammo_label: Label = $Label
@onready var attachment_container: HBoxContainer = $AttachmentContainer

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

	if not arma.ammo_changed.is_connected(_on_ammo_changed):
		arma.ammo_changed.connect(_on_ammo_changed)


func update_display() -> void:
	if not arma or not arma.weapon_data:
		return

	var data: WeaponData = arma.weapon_data

	weapon_sprite.texture = data.gun_texture if data.gun_texture else null

	# Clear existing attachment icons
	for child in attachment_container.get_children():
		child.queue_free()

	# Add attachment icons
	for att in data.attachments:
		if att.icon:
			var icon = TextureRect.new()
			icon.texture = att.icon
			icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			icon.custom_minimum_size = Vector2(20, 20)
			attachment_container.add_child(icon)

	if data.infinite_ammo:
		ammo_label.text = "∞"
	else:
		ammo_label.text = str(arma.municao_atual)


##Signals
func _on_weapon_data_ready() -> void:
	update_display()


func _on_arma_shot() -> void:
	update_display()


func _on_ammo_changed() -> void:
	update_display()
