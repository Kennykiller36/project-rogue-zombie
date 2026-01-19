extends PanelContainer

signal SELECTED(index)

@onready var escolhas_lista = $MarginContainer/EscolhasContainer
@onready var escolhas_prefab = $MarginContainer/EscolhasContainer/EscolhaBtn

var escolhas: Array:
	set(value):
		escolhas = value
		if is_node_ready():
			initButtons()

func _ready():
	escolhas_lista.get_child(0).pressed.connect(onChoice.bind(0))

func initButtons():
	var escolha_btn: Button

	while escolhas_lista.get_child_count() > 1:
		escolha_btn = escolhas_lista.get_child(escolhas_lista.get_child_count() - 1)
		escolhas_lista.remove_child(escolha_btn)
		escolha_btn.queue_free()

	for choice_index in range(escolhas.size()):
		if choice_index == 0:
			escolhas_lista.get_child(0).text = escolhas[choice_index]
		else:
			var novo_botao: Button = escolhas_prefab.duplicate()
			escolhas_lista.add_child(novo_botao)
			novo_botao.text = escolhas[choice_index]
			novo_botao.pressed.connect(onChoice.bind(choice_index))

func onChoice(choice_index: int) -> void:
	visible = false
	SELECTED.emit(choice_index)
