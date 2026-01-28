extends Resource
class_name ItemData

@export var name: String
@export var description: String
@export var price: int
@export var icon: Texture2D
@export_enum("Consumable", "WeaponMod") var type: String
