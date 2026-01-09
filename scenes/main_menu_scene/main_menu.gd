extends Control

func _ready():
	# Garantir que o jogo não está pausado quando o menu é carregado
	get_tree().paused = false

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/test_scene/test_scene.tscn")

func _on_options_pressed():
	var options_menu_script = load("res://scenes/options_menu_scene/options_menu.gd")
	options_menu_script.opened_from_gameplay = false
	get_tree().change_scene_to_file("res://scenes/options_menu_scene/options_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
