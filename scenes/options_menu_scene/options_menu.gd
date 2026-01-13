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


func adicionar_items_modo_janela()-> void:
	for i in ConfigFileHandler.MODO_JANELA_ARRAY:
		janela_button.add_item(i)

func adicionar_items_resolucao()-> void:
	for j in ConfigFileHandler.DICIONARIO_RESOLUCAO:
		resolucao_button.add_item(j)
	
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
	adicionar_items_modo_janela()
	adicionar_items_resolucao()

	# Load saved video settings
	var video_settings = ConfigFileHandler.load_video_settings()
	resolucao_button.selected = video_settings["resolution_index"]
	janela_button.selected = video_settings["window_mode_index"]

	# Load saved audio settings
	var audio_settings = ConfigFileHandler.load_audio_settings()
	$TabContainer/Audio/VBoxContainer/AudioGeralSlider.value = audio_settings["master_volume"]
	$TabContainer/Audio/VBoxContainer/AudioSfxSlider.value = audio_settings["sfx_volume"]
	$TabContainer/Audio/VBoxContainer/AudioMusicaSlider.value = audio_settings["music_volume"]


func _on_resolucao_option_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_setting("resolution_index", index)
	ConfigFileHandler.apply_video_settings()


func _on_janela_option_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_setting("window_mode_index", index)
	ConfigFileHandler.apply_video_settings()


func _on_audio_geral_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("master_volume", $TabContainer/Audio/VBoxContainer/AudioGeralSlider.value)
		ConfigFileHandler.apply_audio_settings()


func _on_audio_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("sfx_volume",$TabContainer/Audio/VBoxContainer/AudioSfxSlider.value)
		ConfigFileHandler.apply_audio_settings()

func _on_audio_musica_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("music_volume",$TabContainer/Audio/VBoxContainer/AudioMusicaSlider.value)
		ConfigFileHandler.apply_audio_settings()
