extends Node2D

const PLAYER_SCENE := preload("res://player.tscn")
const ENEMY := preload("res://enemy_script.gd")

@onready var entities: Node2D = $Entities
@onready var maze: Node2D = $Maze

var player: Node2D

func _ready():
	spawn_player_at(Vector2i(1, 1))

	# Spawn enemy đầu tiên
	spawn_enemy_with_image(
		"res://assets/enemy1.png",
		Vector2i(5, 5)
	)


func spawn_player_at(cell: Vector2i):
	player = PLAYER_SCENE.instantiate()

	entities.add_child(player) # thêm vào Entities, không bị maze che

	var world_pos = maze.cell_to_world(cell)
	player.global_position = world_pos

	# truyền maze reference cho player
	player.maze = maze


func spawn_enemy_with_image(path: String, cell: Vector2i):
	var enemy := ENEMY.new()
	enemy.sprite_path = path

	var world_pos = maze.cell_to_world(cell)
	enemy.global_position = world_pos

	entities.add_child(enemy)  # thêm vào Entities để render trên maze

	return enemy
