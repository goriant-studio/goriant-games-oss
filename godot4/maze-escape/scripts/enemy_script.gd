extends CharacterBody2D

enum PatrolMode { HORIZONTAL, VERTICAL }

@export var sprite_path: String
@export var spawn_at: Vector2i
@export var patrol_mode: PatrolMode = PatrolMode.HORIZONTAL
@export var speed: float = 50.0
@export var patrol_start: float = 2
@export var patrol_end: float = 10    # tile index


var direction := -1  # start moving left
var sprite: Sprite2D
var body_collision: CollisionShape2D
var hit_sfx: AudioStreamPlayer2D
var has_hit_player := false
var hitbox: Area2D
var hitbox_collision: CollisionShape2D

func _init(
	_sprite_path: String = "",
	_spawn_at: Vector2i = Vector2i.ZERO,
	_patrol_mode: PatrolMode = PatrolMode.HORIZONTAL,
	_speed: float = 50.0,
	_patrol_start: int = 2,
	_patrol_end: int = 10
):
	sprite_path = _sprite_path
	spawn_at = _spawn_at
	patrol_mode = _patrol_mode
	speed = _speed
	patrol_start = _patrol_start
	patrol_end = _patrol_end
	_init_hit_sfx()
	hitbox = Area2D.new()
	hitbox_collision = CollisionShape2D.new()
	hitbox.add_child(hitbox_collision)
	add_child(hitbox)
	hitbox.add_to_group("enemy_hitbox")
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	

func _on_hitbox_area_entered(body: Area2D):
	if body.is_in_group("player") and not has_hit_player:
		has_hit_player = true
		if hit_sfx:
			hit_sfx.play()
		
		velocity = Vector2.ZERO
		Globals.emit_player_died()
		

func _init_hit_sfx():
	hit_sfx = AudioStreamPlayer2D.new()
	hit_sfx.stream = preload("res://assets/audio/enemy-hit.wav")
	hit_sfx.volume_db = 10
	add_child(hit_sfx)


func _ready():
	add_to_group("enemy")
	# --- Create Sprite ---
	sprite = Sprite2D.new()
	add_child(sprite)
	# --- Create Collision ---
	body_collision = CollisionShape2D.new()
	add_child(body_collision)
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
	# setup body collision
	var shape := RectangleShape2D.new()
	shape.size = Vector2(Globals.tile_size * 0.9, Globals.tile_size * 0.9)
	body_collision.shape = shape
	self.collision_layer = Utils.layer(3) # enemy body in layer 3
	self.collision_mask = Utils.layer(0) # go through wall
	
	# setup hit box collision
	var hitbox_shape = RectangleShape2D.new()
	hitbox_shape.size = Vector2(Globals.tile_size * 1.1, Globals.tile_size * 1.1) # 1.1 bigger than tile size for easy detect
	hitbox_collision.shape = hitbox_shape
	hitbox.collision_layer = Utils.layer(5) 	# enemy hit box on layer 5
	hitbox.collision_mask = Utils.layer(4) 	# detect player hurt box on layer 4
	
	
func _physics_process(_delta):
	
	if Globals.game_state != Globals.GameState.PLAYING:
		return
	

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
