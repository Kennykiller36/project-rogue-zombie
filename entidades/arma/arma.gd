extends Node2D

signal shot
signal weapon_data_ready

@export var tipo_arma: int = 1 
@export var weapon_data: WeaponData
@onready var sprite: Sprite2D = $Sprite2D

@export var municao_atual: int
var fire_timer: float = 0.0


func _ready() -> void:
	setup_weapon(tipo_arma)


func setup_weapon(weapon_type: int) -> void:
	tipo_arma = weapon_type
	match tipo_arma:
		0, 1:
			weapon_data = preload("res://entidades/arma/pistol.tres").duplicate()
		2:
			weapon_data = preload("res://entidades/arma/shotgun.tres").duplicate()
		3:
			weapon_data = preload("res://entidades/arma/smg.tres").duplicate()
		_:
			push_error("Invalid tipo_arma value!")
			return

	municao_atual = weapon_data.max_ammo

	# Clear attachments for new weapon instance
	weapon_data.attachments.clear()

	if weapon_data.gun_texture:
		sprite.texture = weapon_data.gun_texture
	else:
		push_warning("Gun texture not set in WeaponData!")

	weapon_data_ready.emit()


func mirar() -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	scale.y = -1 if rotation_degrees > 90 and rotation_degrees < 270 else 1


func atira() -> void:
	if !weapon_data.infinite_ammo and municao_atual <= 0:
		return

	if weapon_data.bullet_scene == null:
		push_error("bullet_scene not set in WeaponData!")
		return

	var spread_step := 0.0
	if weapon_data.bullets_per_shot > 1:
		spread_step = weapon_data.spread / (weapon_data.bullets_per_shot - 1)

	var start_angle := rotation - (weapon_data.spread * 0.5)

	for i in range(weapon_data.bullets_per_shot):
		var bullet = weapon_data.bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.rotation = start_angle + (spread_step * i)

	if !weapon_data.infinite_ammo:
		municao_atual = max(municao_atual - 1, 0)
	print(municao_atual)
	shot.emit()


func _process(delta: float) -> void:
	mirar()
	fire_timer -= delta

	if Input.is_action_pressed("fire") and fire_timer <= 0 and not is_menu_open():
		atira()
		fire_timer = weapon_data.fire_rate

func is_menu_open() -> bool:
	var menus = get_tree().get_nodes_in_group("menu")
	for menu in menus:
		if menu.visible:
			return true
	return false
