extends CharacterBody2D

enum PatrolMode { HORIZONTAL, VERTICAL }

var sprite_path: String
var spawn_at: Vector2i
var patrol_mode: PatrolMode = PatrolMode.HORIZONTAL
var speed: float = 50.0
var patrol_start: float = 2
var patrol_end: float = 10    # tile index


var direction := -1  # start moving left
var sprite: Sprite2D
var collision: CollisionShape2D


func _init(_sprite_path:String, 
		_spawn_at : Vector2i, 
		_patrol_mode:PatrolMode, 
		_speed := 50, 
		_patrol_start := 2, 
		_patrol_end := 10):
	sprite_path = _sprite_path
	spawn_at = _spawn_at
	patrol_mode = _patrol_mode
	speed = _speed
	patrol_start = _patrol_start
	patrol_end = _patrol_end
	

func _ready():
	# --- Create Sprite ---
	sprite = Sprite2D.new()
	add_child(sprite)
	# --- Create Collision ---
	collision = CollisionShape2D.new()
	add_child(collision)
	if sprite_path != "":
		load_sprite()

func load_sprite():
	var tex := load(sprite_path)
	if tex == null:
		push_error("Cannot load enemy sprite: " + sprite_path)
		return
	sprite.texture = tex
	# scale image to tile size
	var tex_size = tex.get_size()
	var scale_factor = Globals.tile_size * 1.5 / tex_size.x
	sprite.scale = Vector2(scale_factor, scale_factor)
	# auto collision box
	var shape := RectangleShape2D.new()
	shape.size = Vector2(Globals.tile_size * 0.9, Globals.tile_size * 0.9)
	collision.shape = shape
	self.collision_layer = 3
	self.collision_mask = 2

func _physics_process(delta):
	velocity = Vector2.ZERO

	# Convert patrol to world coords
	var start_pos = patrol_start * Globals.tile_size
	var end_pos = patrol_end * Globals.tile_size

	match patrol_mode:

		# ---------------------------
		#   HORIZONTAL PATROL
		# ---------------------------
		PatrolMode.HORIZONTAL:
			velocity.x = direction * speed

			# Flip logic
			if global_position.x <= start_pos and direction == -1:
				direction = 1
			elif global_position.x >= end_pos and direction == 1:
				direction = -1

		# ---------------------------
		#   VERTICAL PATROL
		# ---------------------------
		PatrolMode.VERTICAL:
			velocity.y = direction * speed

			# Flip logic
			if global_position.y <= start_pos and direction == -1:
				direction = 1
			elif global_position.y >= end_pos and direction == 1:
				direction = -1

	move_and_slide()
