extends Resource
class_name WeaponData

@export var base_damage: int = 10
@export var fire_rate: float = 0.2
@export var max_ammo: int = 10
@export var infinite_ammo: bool = false
@export var bullets_per_shot: int = 1
@export var spread: float = 0.0
@export var bullet_scene: PackedScene
@export var gun_texture: Texture2D
@export var attachments: Array = []
