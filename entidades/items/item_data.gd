extends Resource
class_name ItemData

@export var name: String
@export var description: String
@export var price: int
@export var icon: Texture2D
@export_enum("Consumable", "WeaponMod") var type: String
# For consumables
@export var effect_type: String  # e.g., "heal", "ammo"
@export var effect_value: int
# For weapon mods
@export var mod_stat: String  # e.g., "fire_rate", "max_ammo"
@export var mod_value: float
