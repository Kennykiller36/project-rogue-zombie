extends Node2D

@export var tipo_arma: int = 1  # 1 = Pistol, 2 = Shotgun
@export var infinite_ammo: bool = false
var weapon_data: WeaponData
var current_ammo: int
var fire_timer: float = 0.0

func _ready() -> void:
	match tipo_arma:
		1:
			weapon_data = preload("res://entidades/arma/pistol.tres")
		2:
			weapon_data = preload("res://entidades/arma/shotgun.tres")
		_:
			push_error("Invalid tipo_arma value!")

	if weapon_data:
		current_ammo = weapon_data.max_ammo
	else:
		push_error("WeaponData not assigned!")

func _process(delta: float) -> void:
	mirar()
	fire_timer -= delta
	if Input.is_action_pressed("fire") and fire_timer <= 0:
		atira()
		fire_timer = weapon_data.fire_rate if weapon_data else 0.0

func mirar() -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)

	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1

func atira() -> void:
	if !infinite_ammo and current_ammo <= 0:
		return

	if !weapon_data or !weapon_data.bullet_scene:
		push_error("WeaponData or bullet_scene not set!")
		return

	var base_rotation = rotation
	var spread_step = weapon_data.spread / (weapon_data.bullets_per_shot - 1) if weapon_data.bullets_per_shot > 1 else 0
	var start_angle = base_rotation - (weapon_data.spread / 2)

	for i in range(weapon_data.bullets_per_shot):
		var bullet_rotation = start_angle + (spread_step * i)
		var bullet_instance = weapon_data.bullet_scene.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = global_position
		bullet_instance.rotation = bullet_rotation

	if !infinite_ammo:
		current_ammo -= weapon_data.bullets_per_shot
