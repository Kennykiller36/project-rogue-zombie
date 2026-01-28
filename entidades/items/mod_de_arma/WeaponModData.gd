extends ItemData
class_name WeaponModData

enum Stat { FIRE_RATE, MAX_AMMO, DAMAGE, RELOAD_SPEED }

@export var stat: Stat
@export var multiplier: float = 1.0
@export var flat_bonus: float = 0.0

func apply_to_weapon(weapon_data: WeaponData):
	match stat:
		Stat.FIRE_RATE:
			weapon_data.fire_rate *= multiplier
			weapon_data.fire_rate += flat_bonus
