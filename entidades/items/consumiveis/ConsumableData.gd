extends ItemData
class_name ConsumableData

enum EffectType { HEAL, AMMO }
@export var effect_type: EffectType
@export var effect_value: int

func apply(jogador: Player):
	match effect_type:
		EffectType.HEAL:
			jogador.aumentar_vida(effect_value)
		EffectType.AMMO:
			if jogador.componente_arma:
				jogador.componente_arma.municao_atual+=effect_value
				jogador.componente_arma.ammo_changed.emit()
				#jogador.componente_arma.municao_atual = min(jogador.componente_arma.municao_atual + effect_value, jogador.componente_arma.weapon_data.max_ammo)
