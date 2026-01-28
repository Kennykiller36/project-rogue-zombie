extends ItemData
class_name ConsumableData

enum EffectType { HEAL, AMMO }
@export var effect_type: EffectType
@export var effect_value: int

func apply(jogador: Player):
	match effect_type:
		EffectType.HEAL:
			jogador.aumentar_vida(effect_value)
