extends Control

static var opened_from_gameplay: bool = false
@onready var voltar_jogo_btn = $TabContainer/Geral/VBoxContainer/VoltarJogoBtn
@onready var voltar_hub_btn = $TabContainer/Geral/VBoxContainer/VoltarParaHubBtn
func _update_button_visibility():
	var should_show = opened_from_gameplay
	voltar_jogo_btn.visible = should_show
	voltar_hub_btn.visible = should_show

func _on_voltar_menu_btn_pressed():
	opened_from_gameplay = false  
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu_scene/main_menu.tscn")

func _on_voltar_jogo_btn_pressed():
	opened_from_gameplay = false  
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/test_scene/test_scene.tscn")

func _on_voltar_hub_btn_pressed():
	opened_from_gameplay = false  # Reset flag when going to hub
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu_scene/main_menu.tscn")

##Parte da Tab de video
@onready var janela_button=$TabContainer/Video/VBoxContainerVideoBtn/JanelaOptionBtn as OptionButton

@onready var resolucao_button=$TabContainer/Video/VBoxContainerVideoBtn/ResolucaoOptionBtn as OptionButton


const MODO_JANELA_ARRAY: Array[String]=[
	"Tela cheia", "Janela", "Janela sem borda", "Tela cheia sem borda"
]

func modo_janela_selecionado(index:int)-> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func adicionar_items_modo_janela()-> void:
	for i in MODO_JANELA_ARRAY:
		janela_button.add_item(i)

const DICIONARIO_RESOLUCAO:Dictionary={
	"1152 x 648": Vector2i(1152,648),
	"1280 x 720": Vector2i(1280,720),
	"1920 x 1080": Vector2i(1920,1080),
	"1920 x 1200": Vector2i(1920,1200)
}
func adicionar_items_resolucao()-> void:
	for j in DICIONARIO_RESOLUCAO:
		resolucao_button.add_item(j)
		
func resolucao_selecionada(index:int)-> void:
	DisplayServer.window_set_size(DICIONARIO_RESOLUCAO.values()[index])
	
##Parte da Tab de audio
var audio_bus_master
var audio_bus_sfx
var audio_bus_musica

func _on_audio_geral_slider_value_changed(value):
	var db= linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_master, db)

func _on_audio_sfx_slider_value_changed(value):
	var db= linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_sfx, db)

func _on_audio_musica_slider_value_changed(value):
	var db= linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_musica, db)

##Parte da função ready
func _ready():
	##Parte da tab geral 2
	process_mode = Node.PROCESS_MODE_ALWAYS
	_update_button_visibility()
	
	##Parte da tab audio 2
	audio_bus_master= AudioServer.get_bus_index("Master")
	audio_bus_sfx= AudioServer.get_bus_index("Sfx")
	audio_bus_musica= AudioServer.get_bus_index("Musica")
	
	##Parte da tab video 2
	janela_button.item_selected.connect(modo_janela_selecionado)
	adicionar_items_modo_janela()
	resolucao_button.item_selected.connect(resolucao_selecionada)
	adicionar_items_resolucao()
