# player.gd
extends CharacterBody2D

@export var speed: float = 250.0
@onready var hurtbox: Area2D = $Hurtbox
@onready var sprite: Sprite2D = $Sprite2D

var direction := -1

func _ready():
	hurtbox.add_to_group("player_hurtbox")
	if not hurtbox.area_entered.is_connected(_on_hurtbox_area_entered):
		hurtbox.area_entered.connect(_on_hurtbox_area_entered)


func _physics_process(_delta: float) -> void:
	var input_vector := Vector2.ZERO
	
	# win or lose - stop moving
	if Globals.game_state != Globals.GameState.PLAYING:
		return

	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
		direction = 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
		direction = -1
	
	sprite.flip_h = direction > 0
	
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1

	input_vector = input_vector.normalized()

	velocity = input_vector * speed
	move_and_slide()
	
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if not area.is_in_group("enemy_hitbox"):
		return
		
	if Globals.game_state != Globals.GameState.PLAYING:
		return
		
	print("💀 Player died")
	velocity = Vector2.ZERO
	Globals.emit_player_died()
