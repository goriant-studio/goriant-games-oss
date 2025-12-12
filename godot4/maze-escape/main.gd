extends Node2D

const PLAYER_SCENE := preload("res://player.tscn")
const ENEMY := preload("res://enemy_script.gd")

@onready var entities: Node2D = $Entities
@onready var maze: Node2D = $Maze

var player: Node2D

func _ready():
	spawn_player_at(Vector2i(1, 1))

	# Spawn enemy đầu tiên
	var enemy1 = ENEMY.new("res://assets/enemy1.png", Vector2i(5, 5), ENEMY.PatrolMode.HORIZONTAL, 150)
	var enemy2 = ENEMY.new("res://assets/enemy2.png", Vector2i(10, 4), ENEMY.PatrolMode.VERTICAL, 180)
	var enemy3 = ENEMY.new("res://assets/enemy3.png", Vector2i(12, 11), ENEMY.PatrolMode.HORIZONTAL, 150)
	var enemy4 = ENEMY.new("res://assets/enemy4.png", Vector2i(4, 7), ENEMY.PatrolMode.HORIZONTAL, 150)
	var enemy5 = ENEMY.new("res://assets/enemy5.png", Vector2i(7, 9), ENEMY.PatrolMode.HORIZONTAL, 150)
	
	spawn_enemy(enemy1)
	spawn_enemy(enemy2)
	spawn_enemy(enemy3)
	spawn_enemy(enemy4)
	spawn_enemy(enemy5)
	

func spawn_player_at(cell: Vector2i):
	player = PLAYER_SCENE.instantiate()

	entities.add_child(player) # thêm vào Entities, không bị maze che

	var world_pos = maze.cell_to_world(cell)
	player.global_position = world_pos

	# truyền maze reference cho player
	player.maze = maze


func spawn_enemy(enemy: ENEMY):
	var world_pos = maze.cell_to_world(enemy.spawn_at)
	enemy.global_position = world_pos
	entities.add_child(enemy)  # thêm vào Entities để render trên maze
	return enemy
