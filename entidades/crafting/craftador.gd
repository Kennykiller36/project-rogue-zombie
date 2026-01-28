extends CharacterBody2D

@onready var area := $Area2D

var craft_open := false

func _ready():
	if area:
		area.area_entered.connect(_on_area_entered)

func _on_area_entered(other_area: Area2D):
	if craft_open:
		return

	if other_area.is_in_group("player"):
		open_craft(other_area.get_parent())

func open_craft(jogador: Player):
	if jogador == null:
		return

	var craft_scene = preload("res://scenes/craft/craft.tscn").instantiate()
	get_tree().root.add_child(craft_scene)
	craft_scene.initialize(jogador)

	craft_open = true

	craft_scene.tree_exited.connect(func():
		craft_open = false
	)
