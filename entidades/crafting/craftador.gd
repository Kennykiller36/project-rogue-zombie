extends CharacterBody2D

@onready var area := $Area2D
@onready var interact_prompt := $InteractPrompt

var player_in_range := false
var craft_open := false

func _ready():
	if area:
		area.area_entered.connect(_on_area_entered)
		area.area_exited.connect(_on_area_exited)

	interact_prompt.visible = false


func _on_area_entered(other_area: Area2D):
	if other_area.is_in_group("player"):
		player_in_range = true
		interact_prompt.visible = true


func _on_area_exited(other_area: Area2D):
	if other_area.is_in_group("player"):
		player_in_range = false
		interact_prompt.visible = false


func _process(delta):
	if player_in_range and not craft_open and Input.is_action_just_pressed("interact"):
		open_craft()


func open_craft():
	var jogador = get_tree().get_first_node_in_group("player")
	if jogador == null:
		return

	craft_open = true

	var craft_scene = preload("res://scenes/craft/craft.tscn").instantiate()
	get_tree().root.add_child(craft_scene)
	craft_scene.initialize(jogador)

	craft_scene.tree_exited.connect(func():
		craft_open = false
	)
