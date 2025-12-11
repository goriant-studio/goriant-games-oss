# player.gd
extends CharacterBody2D

@export var speed: float = 250.0

# Optional: reference đến Maze nếu main gán vào
var maze: Node2D

func set_maze(m):
	maze = m


func _physics_process(_delta: float) -> void:
	var input_vector := Vector2.ZERO

	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1

	input_vector = input_vector.normalized()

	velocity = input_vector * speed
	move_and_slide()
