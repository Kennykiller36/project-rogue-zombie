extends Node2D

@onready var options_menu_scene = preload("res://scenes/options_menu_scene/options_menu.tscn")
var options_menu_instance: Control = null
var canvas_layer: CanvasLayer = null

func _ready():
	get_tree().paused = false
	canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	if GameData.selected_player_data:
		$Player.player_data = GameData.selected_player_data
		$Player.player_init()

func _input(event):
	if event.is_action_pressed("pause"):
		if options_menu_instance == null:
			get_tree().paused = true
			options_menu_instance = options_menu_scene.instantiate()
			options_menu_instance.opened_from_gameplay = true
			canvas_layer.add_child(options_menu_instance)
		else:
			_on_resume_game()

func _on_resume_game():
	if options_menu_instance:
		options_menu_instance.queue_free()
		options_menu_instance = null
	get_tree().paused = false
