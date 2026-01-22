extends Node2D

@export var tipo_arma: int = 1 
@export var weapon_data: WeaponData
@onready var sprite: Sprite2D = $Sprite2D

var fire_timer: float = 0.0

func setup_weapon(weapon_type: int) -> void:
	tipo_arma = weapon_type

	match tipo_arma:
		1:
			weapon_data = preload("res://entidades/arma/pistol.tres").duplicate()
		2:
			weapon_data = preload("res://entidades/arma/shotgun.tres").duplicate()
		_:
			push_error("Invalid tipo_arma value!")
			return

	weapon_data.current_ammo = weapon_data.max_ammo

	if weapon_data.gun_texture:
		sprite.texture = weapon_data.gun_texture
	else:
		push_error("Gun texture not set in WeaponData!")

	if weapon_data.gun_texture:
		sprite.texture = weapon_data.gun_texture

func mirar() -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)

	scale.y = -1 if rotation_degrees > 90 and rotation_degrees < 270 else 1

func atira() -> void:
	if !weapon_data.infinite_ammo and weapon_data.current_ammo <= 0:
		return

	if weapon_data.bullet_scene == null:
		push_error("bullet_scene not set in WeaponData!")
		return

	var spread_step := 0.0
	if weapon_data.bullets_per_shot > 1:
		spread_step = weapon_data.spread / (weapon_data.bullets_per_shot - 1)

	var start_angle := rotation - (weapon_data.spread / 2)

	for i in range(weapon_data.bullets_per_shot):
		var bullet = weapon_data.bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.rotation = start_angle + (spread_step * i)

	if !weapon_data.infinite_ammo:
		weapon_data.current_ammo = max(weapon_data.current_ammo - 1, 0)
	
func _process(delta: float) -> void:
	mirar()
	fire_timer -= delta
	if Input.is_action_pressed("fire") and fire_timer <= 0:
		atira()
		fire_timer = weapon_data.fire_rate
