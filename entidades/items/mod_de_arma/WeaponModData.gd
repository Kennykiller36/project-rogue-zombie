extends ItemData
class_name WeaponModData

enum Stat { FIRE_RATE, DAMAGE }

@export var stat: Stat
@export var multiplier: float = 1.0
@export var flat_bonus: float = 0.0

func apply_to_weapon(weapon_data: WeaponData):
	match stat:
		Stat.FIRE_RATE:
			var old_fire_rate := weapon_data.fire_rate
			weapon_data.fire_rate *= multiplier
			weapon_data.fire_rate += flat_bonus
			print("Fire rate changed from %.2f to %.2f"% [old_fire_rate, weapon_data.fire_rate])
		Stat.DAMAGE:
			var old_damage := weapon_data.base_damage
			weapon_data.base_damage = int(weapon_data.base_damage * multiplier + flat_bonus)
			print("Damage changed from %d to %d" % [old_damage, weapon_data.base_damage])
