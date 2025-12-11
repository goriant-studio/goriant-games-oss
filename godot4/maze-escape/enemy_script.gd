extends CharacterBody2D

@export var speed: float = 50.0
@export var patrol_left_x: float
@export var patrol_right_x: float

var sprite_path: String = ""

var direction := -1  # start moving left

var sprite: Sprite2D
var collision: CollisionShape2D

func _init():
	sprite = Sprite2D.new()
	
	add_child(sprite)

	collision = CollisionShape2D.new()
	add_child(collision)

func _ready():
	if sprite_path != "":
		load_sprite()

func load_sprite():
	var tex := load(sprite_path)
	if tex == null:
		push_error("Cannot load enemy sprite: " + sprite_path)
		return

	sprite.texture = tex

	# --- AUTO SCALE TO TILE SIZE ---
	var tex_size = tex.get_size()
	# scale factor cho width và height
	var scale_factor = Globals.tile_size / tex_size.x
	# Apply uniform scale (giữ nguyên tỷ lệ ảnh)
	sprite.scale = Vector2(scale_factor, scale_factor)
	# Auto collision box
	var shape := RectangleShape2D.new()
	shape.size = Vector2(Globals.tile_size * 0.9, Globals.tile_size * 0.9)
	collision.shape = shape
	self.set_collision_layer_value(3, true)
	self.set_collision_mask_value(2, true)


func _physics_process(_delta):
	velocity.x = direction * speed
	move_and_slide()

	var left_x = patrol_left_x * Globals.tile_size
	var right_x = patrol_right_x * Globals.tile_size

	if global_position.x < left_x:
		direction = 1
	elif global_position.x > right_x:
		direction = -1
