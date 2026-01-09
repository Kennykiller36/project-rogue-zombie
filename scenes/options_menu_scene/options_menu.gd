extends Control

##Parte dos botões da tab geral
static var opened_from_gameplay: bool = false
@onready var voltar_jogo_btn = $TabContainer/Geral/VoltarJogoBtn
@onready var voltar_hub_btn = $TabContainer/Geral/VoltarParaHubBtn
func _update_button_visibility():
	var should_show = opened_from_gameplay
	voltar_jogo_btn.visible = should_show
	voltar_hub_btn.visible = should_show

func _on_voltar_menu_btn_pressed():
	opened_from_gameplay = false  
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
	process_mode = Node.PROCESS_MODE_ALWAYS
	audio_bus_master= AudioServer.get_bus_index("Master")
	audio_bus_sfx= AudioServer.get_bus_index("Sfx")
	audio_bus_musica= AudioServer.get_bus_index("Musica")
	
	_update_button_visibility()
