extends Node

enum GameState { PLAYING, WIN, LOSE }

signal game_state_changed(state)
signal treasure_collected
signal player_died

func emit_treasure_collected():
	emit_signal("treasure_collected")

func emit_player_died():
	emit_signal("player_died")

# ----- LEVEL FLOW -----
var levels := [
	"res://scenes/level/level_1.tscn",
	"res://scenes/level/level_2.tscn",
	"res://scenes/level/level_3.tscn",
]

var current_level_index := 0

var game_state: GameState = GameState.PLAYING:
	set(value):
		if game_state == value:
			return
		game_state = value
		emit_signal("game_state_changed", value)


func beat_the_game():
	print("current level: " + str(current_level_index))
	print("levels.size()" + str(levels.size()))
	return current_level_index + 1 >= levels.size()
		
		
func go_to_next_level():
	current_level_index += 1

	if current_level_index >= levels.size():
		print("🎉 All levels completed!")
		current_level_index = 0
		# có thể quay về menu / credit
		get_tree().change_scene_to_file("res://scenes/main_game.tscn")
		return
	get_tree().change_scene_to_file(levels[current_level_index])
		
		
var tile_size: int = 64
var current_level = 1
