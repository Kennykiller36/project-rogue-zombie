extends CharacterBody2D
class_name Player

##Hud
@onready var barra_hp=$"CanvasHud/BarraDeHp"
@onready var barra_habilidade=$"CanvasHud/BarraDeHabilidade"
var saude
var carga_habilidade
##Movimento player
const max_speed := 40.0
const min_speed := 8.0
const time_to_max_speed := 0.1
const time_to_stop := 0.05
const time_to_turn := 0.05
const acceleration := max_speed / time_to_max_speed
const friction := max_speed / time_to_stop
const turn_speed := max_speed / time_to_turn
var dir_input := Vector2.ZERO

func _ready():
	saude = 100
	carga_habilidade = 100
	if barra_hp:
		barra_hp.init_health(saude)
	else:
		print("Warning: Player: BarraDeHp node not found at path ../CanvasLayer/BarraDeHp")

##Movimento player 2
func _physics_process(delta: float) -> void:
	dir_input = Input.get_vector("left", "right", "up", "down")
	if dir_input != Vector2.ZERO:
		if !dir_input.normalized().is_equal_approx(velocity.normalized()):
			velocity += dir_input * turn_speed * delta
		else:
			velocity += dir_input * acceleration * delta
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	elif velocity != Vector2.ZERO:
		velocity -= velocity.normalized() * friction * delta 
		if velocity.length() < min_speed:
			velocity = Vector2.ZERO
	move_and_slide()

##Chamadas para HP
func aumentar_vida():
	if saude >= 100:
		return
	saude += 10
	if barra_hp:
		barra_hp.hp = saude

func diminuir_vida():
	if saude <= 0:
		return
	saude -= 10
	if barra_hp:
		barra_hp.hp = saude
		
##Chamadas para Habilidade
func aumentar_habilidade():
	if carga_habilidade >= 100:
		return
	carga_habilidade += 10
	if barra_habilidade:
		barra_habilidade.carga_habilidade = carga_habilidade

func diminuir_habilidade():
	if carga_habilidade <= 0:
		return
	carga_habilidade -= 10
	if barra_habilidade:
		barra_habilidade.carga_habilidade = carga_habilidade
	
func _input(event):
	if event.is_action_pressed("addHealth"):
		aumentar_vida()
	if event.is_action_pressed("loseHealth"):
		diminuir_vida()
	if event.is_action_pressed("addHabilidade"):
		aumentar_habilidade()
	if event.is_action_pressed("loseHabilidade"):
		diminuir_habilidade()
