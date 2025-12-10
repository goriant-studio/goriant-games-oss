# main.gd
extends Node2D

const PLAYER_SCENE := preload("res://Player.tscn")

@onready var maze: Node2D = $Maze
var player: Node2D

func _ready():
	spawn_player_at(Vector2i(1, 1))
	

func spawn_player_at(cell: Vector2i):
	player = PLAYER_SCENE.instantiate()
	add_child(player)

	var world_pos = maze.cell_to_world(cell)
	player.global_position = world_pos

	# truyền maze reference
	player.maze = maze
