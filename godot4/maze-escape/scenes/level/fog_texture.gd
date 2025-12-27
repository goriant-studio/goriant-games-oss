extends Sprite2D

@export var target_tilemap_path: NodePath
@export var fog_color := Color(0, 0, 0, 0.99)
@export var reveal_radius := 56.0

# Performance
@export var update_interval := 0.05
@export var min_move_distance := 12.0
@export var grid_size := 16

@export var debug_print := false

var fog_image: Image
var fog_texture_obj: ImageTexture
var image_size := Vector2.ZERO

var time_since_update := 0.0
var time_since_save := 0.0
var has_last := false
var last_world_pos := Vector2(-9999, -9999)

# Track revealed grids (this is what we save)
var revealed_grid := {}  # Dictionary<Vector2i, bool>

const TRANSPARENT := Color(0, 0, 0, 0)

func _ready() -> void:
	z_index = 999999
	centered = false
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	_init_from_tilemap()
	print("global_position.x ", global_position.x, " global_position.y ", global_position.y)

	var w := int(image_size.x)
	var h := int(image_size.y)
	
	print("w ", w, " h ", h)

	fog_image = Image.create(w, h, false, Image.FORMAT_RGBA8)
	fog_image.fill(fog_color)

	fog_texture_obj = ImageTexture.create_from_image(fog_image)
	texture = fog_texture_obj
	

	print("✅ Fog PERMANENT v7 | size=", w, "x", h, " | revealed_grids=", revealed_grid.size())
	
	# IMPORTANT: Reveal player start position immediately
	await get_tree().process_frame  # Wait 1 frame for player to be ready
	_reveal_player_start_position()

func _process(delta: float) -> void:
	time_since_update += delta


func reveal_area(world_pos: Vector2) -> void:
	# Throttle updates
	if has_last:
		if time_since_update < update_interval and last_world_pos.distance_to(world_pos) < min_move_distance:
			return

	time_since_update = 0.0
	last_world_pos = world_pos
	has_last = true

	_permanent_reveal(world_pos)

var map_used_rect: Rect2i
var map_tile_size: Vector2
var map_tilemap: TileMapLayer

# ----------------------------
# Align fog to TileMap
# ----------------------------
func _init_from_tilemap() -> void:
	var node := get_node_or_null(target_tilemap_path)
	if node == null or not (node is TileMapLayer):
		print("NOT FOUND - DEFAULT SUCK")
		image_size = Vector2(2048, 2048)
		global_position = Vector2.ZERO
		return

	map_tilemap = node as TileMapLayer
	map_used_rect = map_tilemap.get_used_rect()

	var ts := map_tilemap.tile_set.tile_size
	map_tile_size = Vector2(ts.x, ts.y)

	# map size gốc
	image_size = Vector2(
		map_used_rect.size.x * map_tile_size.x,
		map_used_rect.size.y * map_tile_size.y
	)

	# map top-left
	var top_left_center := map_tilemap.map_to_local(map_used_rect.position)
	var top_left_local := top_left_center - map_tile_size * 0.5
	var top_left_global := map_tilemap.to_global(top_left_local)

	# 🔥 lùi về trái + trên = nửa map
	global_position = top_left_global


# ----------------------------
# PERMANENT REVEAL - fog xóa vĩnh viễn
# ----------------------------
func _permanent_reveal(world_pos: Vector2) -> void:
	# CRITICAL: to_local() converts player global_position to fog's local pixel space
	var local: Vector2 = to_local(world_pos)

	if debug_print:
		print("🔍 World=", world_pos.snapped(Vector2.ONE), 
			  " → Local=", local.snapped(Vector2.ONE),
			  " | FogPos=", global_position.snapped(Vector2.ONE),
			  " | FogSize=", image_size.snapped(Vector2.ONE))

	# Bounds check (CORRECT – circle vs rect)
	var fog_rect := Rect2(Vector2.ZERO, image_size)

	# Bounding box của vòng tròn reveal
	var reveal_rect := Rect2(
		local - Vector2(reveal_radius, reveal_radius),
		Vector2(reveal_radius * 2, reveal_radius * 2)
	)

	# Chỉ reject khi KHÔNG có giao nhau
	if not fog_rect.intersects(reveal_rect):
		if debug_print:
			print("   ❌ Out of bounds (no intersection)")
		return


	# Grid-based deduplication
	var gx := int(local.x / grid_size)
	var gy := int(local.y / grid_size)
	var key := Vector2i(gx, gy)
	
	if revealed_grid.has(key):
		return  # Already revealed, skip
	
	revealed_grid[key] = true
	
	if debug_print:
		print("   ✅ Revealing grid (", gx, ", ", gy, ")")
	
	# Actually clear the fog pixels
	_draw_circle_clear(local, reveal_radius)
	
	# Update texture
	fog_texture_obj.update(fog_image)

func _draw_circle_clear(center: Vector2, radius: float) -> void:
	var img_w := fog_image.get_width()
	var img_h := fog_image.get_height()
	var radius_sq := radius * radius

	var min_x := maxi(0, int(center.x - radius))
	var max_x := mini(img_w - 1, int(center.x + radius))
	var min_y := maxi(0, int(center.y - radius))
	var max_y := mini(img_h - 1, int(center.y + radius))

	var cleared := 0

	for py in range(min_y, max_y + 1):
		var dy := float(py) - center.y
		var dy_sq := dy * dy
		for px in range(min_x, max_x + 1):
			var dx := float(px) - center.x
			if dx * dx + dy_sq <= radius_sq:
				fog_image.set_pixel(px, py, TRANSPARENT)
				cleared += 1

	if debug_print:
		print("🟢 Fog clear circle | center=", center.snapped(Vector2.ONE),
			  " radius=", radius,
			  " pixels=", cleared)


# Reconstruct fog image from saved revealed_grid
func _reconstruct_fog_from_revealed_grid() -> void:
	# Reset fog completely
	fog_image.fill(fog_color)
	
	# Re-reveal all saved grids
	for key in revealed_grid.keys():
		var grid_center := Vector2(
			(key.x + 0.5) * grid_size,
			(key.y + 0.5) * grid_size
		)
		_draw_circle_clear(grid_center, reveal_radius)
	
	# Update texture
	fog_texture_obj.update(fog_image)
	
	print("🔄 Reconstructed fog from ", revealed_grid.size(), " saved grids")

# ----------------------------
# REVEAL PLAYER START POSITION
# ----------------------------
func _reveal_player_start_position() -> void:
	var player = get_tree().get_first_node_in_group("player_with_light")
	if player == null:
		push_warning("⚠️ Player not found in group 'player_with_light'")
		return
	
	var player_pos: Vector2 = player.global_position
	print("🎯 Revealing player start position: ", player_pos)
	
	# Force reveal without throttling
	has_last = false
	time_since_update = 999.0
	reveal_area(player_pos)
	
	# Double-check it worked
	await get_tree().process_frame
	var local := to_local(player_pos)
	print("   → Player local in fog: ", local.snapped(Vector2.ONE), " / ", image_size)
