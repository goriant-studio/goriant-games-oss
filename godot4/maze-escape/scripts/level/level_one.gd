extends Node2D

const PLAYER_SCENE := preload("res://scenes/player.tscn")
const TREASURE_SCENE := preload("res://scenes/treasure.tscn")
const ENEMY := preload("res://scripts/enemy_script.gd")

@onready var entities: Node2D = $Entities
@onready var maze = $Maze

var player
var treasure

func _ready():
	# ⭐️ CỰC KỲ QUAN TRỌNG
	get_tree().paused = false
	Globals.game_state = Globals.GameState.PLAYING

	spawn_treasure()

	# Spawn enemies
	spawn_enemy(ENEMY.new("res://assets/enemy1.png", Vector2i(5, 5), ENEMY.PatrolMode.HORIZONTAL, 150))
	spawn_enemy(ENEMY.new("res://assets/enemy2.png", Vector2i(10, 4), ENEMY.PatrolMode.VERTICAL, 180))
	spawn_enemy(ENEMY.new("res://assets/enemy3.png", Vector2i(12, 11), ENEMY.PatrolMode.HORIZONTAL, 150))
	spawn_player_at(Vector2i(1, 1))

func spawn_treasure():
	treasure = TREASURE_SCENE.instantiate()
	entities.add_child(treasure)

	var world_pos = maze.cell_to_world(Vector2i(1, 3))
	treasure.global_position = world_pos


func spawn_player_at(cell: Vector2i):
	player = PLAYER_SCENE.instantiate()
	entities.add_child(player)

	player.global_position = maze.cell_to_world(cell)
	player.maze = maze

func spawn_enemy(enemy):
	enemy.global_position = maze.cell_to_world(enemy.spawn_at)
	entities.add_child(enemy)
