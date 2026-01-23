extends Control

func _on_policial_pressed():
	GameData.selected_player_data = preload("res://entidades/player/policial.tres")
	get_tree().change_scene_to_file("res://scenes/test_scene/test_scene.tscn")

func _on_prisioneiro_pressed():
	GameData.selected_player_data = preload("res://entidades/player/prisioneiro.tres")
	get_tree().change_scene_to_file("res://scenes/test_scene/test_scene.tscn")
