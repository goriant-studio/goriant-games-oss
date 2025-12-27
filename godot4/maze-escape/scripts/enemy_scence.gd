extends CharacterBody2D
class_name Enemy

signal player_hit(enemy: Enemy, player: Node2D)
signal hit_player
enum PatrolMode { HORIZONTAL, VERTICAL }

# --------- CONFIG (chỉ thay data) ----------
@export var sprite_texture: Texture2D
@export var patrol_mode: PatrolMode = PatrolMode.HORIZONTAL
@export var speed: float = 150.0
@export var patrol_start: int = 2
@export var patrol_end: int = 10

# --------- REQUIRED NODES ----------
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var body_collision: CollisionShape2D = $CollisionShape2D

var game_ui: CanvasLayer = null
var direction: int = -1
var has_hit_player: bool = false
var hit_sfx: AudioStreamPlayer2D

var spawn_position: Vector2
var start_world_pos: Vector2
var end_world_pos: Vector2

func _ready() -> void:
	assert(sprite != null, "Enemy requires Sprite2D")
	assert(hitbox != null, "Enemy requires Hitbox (Area2D)")
	assert(hitbox_collision != null, "Enemy requires CollisionShape2D")

	_init_hit_sfx()

	hitbox.add_to_group("enemy_hitbox")
	if not hitbox.area_entered.is_connected(_on_hitbox_area_entered):
		hitbox.area_entered.connect(_on_hitbox_area_entered)
	apply_sprite()
	setup_collision()
	
	spawn_position = global_position
	
	# Tính world position từ offset
	match patrol_mode:
		PatrolMode.HORIZONTAL:
			start_world_pos = spawn_position + Vector2(patrol_start * Globals.tile_size, 0)
			end_world_pos = spawn_position + Vector2(patrol_end * Globals.tile_size, 0)
		PatrolMode.VERTICAL:
			start_world_pos = spawn_position + Vector2(0, patrol_start * Globals.tile_size)
			end_world_pos = spawn_position + Vector2(0, patrol_end * Globals.tile_size)

	

func _on_hitbox_area_entered(body: Node2D) -> void:
	# Chỉ hit player
	if not body.is_in_group("player_hurtbox"):
		return
		
	print("ENTER player ✅ state=%s hit=%s" % [Globals.game_state, has_hit_player])		

	# Chặn hit lặp
	if has_hit_player:
		return
	has_hit_player = true

	print("Enemy hit player event trigger")
	emit_signal("hit_player")

func _init_hit_sfx() -> void:
	hit_sfx = AudioStreamPlayer2D.new()
	hit_sfx.stream = preload("res://assets/audio/enemy-hit.wav")
	hit_sfx.process_mode = Node.PROCESS_MODE_ALWAYS
	# hit_sfx.bus = "SFX" # nếu bạn có bus
	add_child(hit_sfx)

func apply_sprite() -> void:
	assert(sprite_texture != null, "Enemy sprite_texture is required")
	sprite.texture = sprite_texture
	sprite.apply_scale(Vector2(0.05, 0.05))

func setup_collision() -> void:
	var body_shape := RectangleShape2D.new()
	body_shape.size = Vector2(Globals.tile_size * 1.1, Globals.tile_size * 1.1)
	body_collision.shape = body_shape
	
	# Body (CharacterBody2D) collide với world và enemies (nếu muốn push nhau)
	self.collision_layer = Utils.layer(3)  # layer 3: Enemies
	self.collision_mask = Utils.layer(0)   # go through wall
	
	var shape := RectangleShape2D.new()
	shape.size = Vector2(Globals.tile_size * 1.1, Globals.tile_size * 1.1)
	hitbox_collision.shape = shape
	
	hitbox.collision_layer = Utils.layer(5) 	# enemy hit box on layer 5
	hitbox.collision_mask = Utils.layer(4) 		# detect player hurt box on layer 4
	
	body_collision.disabled = false
	hitbox_collision.disabled = false

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO

	#var start_pos := patrol_start * Globals.tile_size
	#var end_pos := patrol_end * Globals.tile_size

	match patrol_mode:
		PatrolMode.HORIZONTAL:
			velocity.x = direction * speed
			if global_position.x <= start_world_pos.x:
				direction = 1
			elif global_position.x >= end_world_pos.x:
				direction = -1
			sprite.flip_h = direction > 0
			
		PatrolMode.VERTICAL:
			velocity.y = direction * speed
			if global_position.y <= start_world_pos.y:
				direction = 1
			elif global_position.y >= end_world_pos.y:
				direction = -1

	move_and_slide()
