extends Button

@export var gameplay_scene_path := "res://scenes/test_scene/test_scene.tscn"
# ↑ change this to your actual gameplay scene path

func _ready():
	_update_visibility()

func _process(_delta):
	_update_visibility()

func _update_visibility():
	var is_paused = get_tree().paused
	var current_scene = get_tree().current_scene

	var is_in_game := (
		current_scene != null
		and current_scene.scene_file_path == gameplay_scene_path
	)

	visible = is_paused and is_in_game
