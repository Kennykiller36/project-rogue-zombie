extends CharacterBody2D

@export var dano:int
@export var saude:int
const speed=20
@export var player:Node2D
@onready var nav_agent:=$NavigationAgent2D as NavigationAgent2D

##Vida e dano do inimigo
func diminuir_vida(dano: int):
	if saude <= 0:
		queue_free()
	saude -= dano

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var player = area.get_parent() 
		player.diminuir_vida(dano)


##Navegação
func _physics_process(delta: float) -> void:
	var dir=to_local(nav_agent.get_next_path_position()).normalized()
	velocity=dir*speed
	move_and_slide()

func makePath()-> void:
	nav_agent.target_position=player.global_position
	
func _on_timer_timeout() -> void:
	makePath()

func _ready() -> void:
	makePath()
