extends Control

var audio_bus_master
var audio_bus_sfx
var audio_bus_musica

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	audio_bus_master= AudioServer.get_bus_index("Master")
	audio_bus_sfx= AudioServer.get_bus_index("Sfx")
	audio_bus_musica= AudioServer.get_bus_index("Musica")



func _on_voltar_menu_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu_scene/main_menu.tscn")
 # Replace with function body.


func _on_audio_geral_slider_value_changed(value):
	var db= linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_master, db)


func _on_audio_sfx_slider_value_changed(value):
	var db= linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_sfx, db)



func _on_audio_musica_slider_value_changed(value):
	var db= linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_musica, db)
