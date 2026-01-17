extends Node2D

const BALA = preload("res://entidades/bala/bullet.tscn")

@export var infinite_ammo: bool = false
@export var max_ammo: int = 10
var current_ammo: int

func _ready() -> void:
	current_ammo = max_ammo

func atira() -> void:
	# Stop firing if out of ammo and not infinite
	if !infinite_ammo and current_ammo <= 0:
		return

	var bullet_instance = BALA.instantiate()
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.rotation = rotation

	if !infinite_ammo:
		current_ammo -= 1

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)

	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1

	if Input.is_action_just_pressed("fire"):
		atira()
