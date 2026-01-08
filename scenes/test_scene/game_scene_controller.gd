extends Node2D

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		# Mark that we're opening options from gameplay
		var options_menu_script = load("res://scenes/options_menu_scene/options_menu.gd")
		options_menu_script.opened_from_gameplay = true
		get_tree().change_scene_to_file("res://scenes/options_menu_scene/options_menu.tscn")
