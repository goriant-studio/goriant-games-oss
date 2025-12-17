extends CharacterBody2D
class_name Enemy

enum PatrolMode { HORIZONTAL, VERTICAL }

# --------- CONFIG (chỉ thay data) ----------
@export var sprite_texture: Texture2D
@export var patrol_mode: PatrolMode = PatrolMode.HORIZONTAL
@export var speed: float = 150.0
@export var patrol_start: int = 2
@export var patrol_end: int = 10

# --------- REQUIRED NODES ----------
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var direction := -1

func _ready():
	assert(sprite != null, "Enemy requires Sprite2D")
	assert(collision != null, "Enemy requires CollisionShape2D")

	apply_sprite()
	setup_collision()

func apply_sprite():
	assert(sprite_texture != null, "Enemy sprite_texture is required")
	sprite.texture = sprite_texture

func setup_collision():
	var shape := RectangleShape2D.new()
	shape.size = Vector2(
		Globals.tile_size * 0.9,
		Globals.tile_size * 0.9
	)
	collision.shape = shape
	collision_layer = 3
	collision_mask = 2


func _physics_process(delta):
	velocity = Vector2.ZERO

	var start_pos = patrol_start * Globals.tile_size
	var end_pos = patrol_end * Globals.tile_size

	match patrol_mode:
		PatrolMode.HORIZONTAL:
			velocity.x = direction * speed
			if global_position.x <= start_pos:
				direction = 1
			elif global_position.x >= end_pos:
				direction = -1
			sprite.flip_h = direction > 0

		PatrolMode.VERTICAL:
			velocity.y = direction * speed
			if global_position.y <= start_pos:
				direction = 1
			elif global_position.y >= end_pos:
				direction = -1

	move_and_slide()
