extends Node

enum GameState { PLAYING, WIN, LOSE }

signal game_state_changed(state)

# ----- LEVEL FLOW -----
var levels := [
	"res://scenes/level/level_1.tscn",
	"res://scenes/level/level_2.tscn",
]

var current_level_index := 0

var game_state: GameState = GameState.PLAYING:
	set(value):
		if game_state == value:
			return
		game_state = value
		emit_signal("game_state_changed", value)
		
		
func go_to_next_level():
	current_level_index += 1

	if current_level_index >= levels.size():
		print("🎉 All levels completed!")
		# có thể quay về menu / credit
		get_tree().change_scene_to_file("res://scenes/main_game.tscn")
		return
	get_tree().change_scene_to_file(levels[current_level_index])
		
		
var tile_size: int = 64
var current_level = 1
