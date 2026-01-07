extends Node2D

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/options_menu_scene/options_menu.tscn")
