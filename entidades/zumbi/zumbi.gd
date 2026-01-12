extends CharacterBody2D

@export var dano:int
@export var saude:int

func diminuir_vida(dano: int):
	if saude <= 0:
		return
	saude -= dano

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var player = area.get_parent() 
		player.diminuir_vida(dano)
