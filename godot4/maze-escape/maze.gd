extends Node2D

var walls_parent: Node2D
var wall_texture: Texture2D

var maze_30x16 := [
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,0,0,0,1,0,1,0,0,0,0,1,0,0,1,0,1,0,0,0,1,0,1,0,0,0,0,0,0,1],
	[1,0,1,0,1,0,1,0,1,1,0,1,0,1,1,0,1,1,1,0,1,0,1,0,1,1,0,1,0,1],
	[1,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,0,1,0,1],
	[1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,0,1,0,1,1,1,1,0,1,0,1,0,1],
	[1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1],
	[1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,0,1,1,1,1,1,1,1,1,0,1,0,1],
	[1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,0,1],
	[1,0,1,0,1,1,1,1,1,1,1,0,1,1,1,0,1,0,1,1,1,0,1,1,1,1,0,1,0,1],
	[1,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1,0,1,0,1],
	[1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,0,1,1,1,1,1,1,1,0,1,1,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
]


func _ready():
	# Draw maze at beginning
	position = Vector2(0,0)

	# Create parent for walls
	walls_parent = get_node_or_null("Walls")
	if walls_parent == null:
		walls_parent = Node2D.new()
		walls_parent.name = "Walls"
		add_child(walls_parent)

	# Create texture for wall tiles
	wall_texture = create_solid_color_texture(Globals.tile_size, Globals.tile_size, Color.BLACK)

	# Build maze
	generate_walls(maze_30x16)	


func generate_walls(grid):
	# Remove previous tiles
	for child in walls_parent.get_children():
		child.queue_free()

	var h: int = grid.size()
	var w: int = grid[0].size()

	for y in range(h):
		for x in range(w):
			if grid[y][x] == 1:
				create_wall(x, y)


func create_wall(col: int, row: int):
	var pos := Vector2(
		col * Globals.tile_size + Globals.tile_size / 2.0,
		row * Globals.tile_size + Globals.tile_size / 2.0
	)

	var wall := StaticBody2D.new()
	wall.position = pos

	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(Globals.tile_size, Globals.tile_size)
	shape.shape = rect

	var sprite := Sprite2D.new()
	sprite.texture = wall_texture

	wall.add_child(shape)
	wall.add_child(sprite)
	# set collision & mask
	wall.collision_layer = 1
	wall.collision_mask = 0
	
	walls_parent.add_child(wall)


func create_solid_color_texture(width: int, height: int, color: Color) -> Texture2D:
	var img := Image.create(width, height, false, Image.FORMAT_RGBA8)
	img.fill(color)  # faster than set_pixel loops
	return ImageTexture.create_from_image(img)
	
	
func cell_to_world(cell: Vector2i) -> Vector2:
	return Vector2(
		cell.x * Globals.tile_size + Globals.tile_size * 0.5,
		cell.y * Globals.tile_size + Globals.tile_size * 0.5
	)
	
	
