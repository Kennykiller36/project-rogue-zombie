extends CharacterBody2D

@export var enemy_data: EnemyData
# Local (runtime) stats
var player: Node2D
var current_health: int
var damage: int
var speed: float
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var sprite_component := $Sprite as Sprite2D


func diminuir_vida(dano_recebido: int) -> void:
	current_health -= dano_recebido
	if current_health <= 0:
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var player_node := area.get_parent()
		if player_node.has_method("diminuir_vida"):
			player_node.diminuir_vida(damage)

func makePath() -> void:
	if player:
		nav_agent.target_position = player.global_position


func _on_timer_timeout() -> void:
	makePath()

func find_player() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	if not player:
		push_warning(
			"Enemy spawned but no player found in group '" + enemy_data.player + "'"
		)

## Navegação
func _physics_process(delta: float) -> void:
	if not player or nav_agent.is_navigation_finished():
		return

	var dir := to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()

func _ready() -> void:
	if not enemy_data:
		push_error("Enemy spawned without EnemyData!")
		return

	current_health = enemy_data.vidamaxima
	damage = enemy_data.dano
	speed = enemy_data.velocidade

	if enemy_data.sprite_texture:
		sprite_component.texture = enemy_data.sprite_texture

	find_player()
	makePath()
