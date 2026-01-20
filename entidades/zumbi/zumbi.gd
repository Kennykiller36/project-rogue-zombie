extends CharacterBody2D

@export var dano: int
@export var saude: int
const speed := 20

var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

## Vida e dano do inimigo
func diminuir_vida(dano: int) -> void:
	if saude <= 0:
		queue_free()
		return
	saude -= dano

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var player_node := area.get_parent()
		if player_node.has_method("diminuir_vida"):
			player_node.diminuir_vida(dano)

## Navegação
func _physics_process(delta: float) -> void:
	if not player:
		return

	var dir := to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()

func makePath() -> void:
	if player:
		nav_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	makePath()

func _ready() -> void:
	find_player()
	makePath()

func find_player() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	if not player:
		push_warning("Enemy spawned but no player found in group 'player'")
