extends Button

@export var gameplay_scene_path := "res://scenes/test_scene/test_scene.tscn"

func _ready():
	_update_visibility()
	pressed.connect(_on_pressed)

func _process(_delta):
	_update_visibility()

func _update_visibility():
	visible = get_tree().paused

func _on_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(gameplay_scene_path)
