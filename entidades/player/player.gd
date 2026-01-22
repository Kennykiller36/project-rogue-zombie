extends CharacterBody2D
class_name Player

## HUD
@onready var barra_hp = $"CanvasHud/BarraDeHp"
@onready var barra_habilidade = $"CanvasHud/BarraDeHabilidade"

## Components
@onready var componente_arma = $arma
@onready var componente_sprite = $SpritePlayer

## Data
@export var player_data: PlayerData

## Runtime state
var saude: int
var carga_habilidade: int = 100

## Movimento
var max_speed: float
var min_speed := 8.0
const TIME_TO_MAX_SPEED := 0.1
const TIME_TO_STOP := 0.05
const TIME_TO_TURN := 0.05

var acceleration: float
var friction: float
var turn_speed: float
var dir_input := Vector2.ZERO

func _ready() -> void:
	player_init()
	if barra_hp:
		barra_hp.init_health(saude)
	else:
		push_warning("BarraDeHp não encontrada")



func player_init() -> void:
	if player_data == null:
		push_error("PlayerData não atribuído!")
		return
	saude = player_data.saudeMaxima
	max_speed = player_data.velocidade
	acceleration = max_speed / TIME_TO_MAX_SPEED
	friction = max_speed / TIME_TO_STOP
	turn_speed = max_speed / TIME_TO_TURN
	componente_sprite.texture = player_data.sprite
	componente_arma.setup_weapon(player_data.armaInicial)
	
func _physics_process(delta: float) -> void:
	dir_input = Input.get_vector("left", "right", "up", "down")

	if dir_input != Vector2.ZERO:
		if velocity != Vector2.ZERO \
		and !dir_input.normalized().is_equal_approx(velocity.normalized()):
			velocity += dir_input * turn_speed * delta
		else:
			velocity += dir_input * acceleration * delta

		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	else:
		if velocity.length() > 0:
			velocity -= velocity.normalized() * friction * delta
			if velocity.length() < min_speed:
				velocity = Vector2.ZERO
	move_and_slide()


func aumentar_vida() -> void:
	if saude >= player_data.saudeMaxima:
		return
	saude = min(saude + 10, player_data.saudeMaxima)
	barra_hp.hp = saude

func diminuir_vida(dano: int) -> void:
	if saude <= 0:
		return
	saude = max(saude - dano, 0)
	barra_hp.hp = saude
	if saude == 0:
		morrer()

func morrer() -> void:
	queue_free()

func aumentar_habilidade() -> void:
	if carga_habilidade >= 100:
		return
	carga_habilidade = min(carga_habilidade + 10, 100)
	barra_habilidade.carga_habilidade = carga_habilidade

func usarHabilidade() -> void:
	if carga_habilidade < 100:
		return
	carga_habilidade = 0
	barra_habilidade.carga_habilidade = carga_habilidade
	print("A sua habilidade é: "+player_data.habilidadeEspecial)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("addHealth"):
		aumentar_vida()
	elif event.is_action_pressed("loseHealth"):
		diminuir_vida(10)
	elif event.is_action_pressed("addHabilidade"):
		aumentar_habilidade()
	elif event.is_action_pressed("usarHabilidade"):
		usarHabilidade()
