extends Node

# ----- GAME CONFIG -----
var tile_size: int = 32
var current_level := 1

enum GameState { NONE, PLAYING, WIN, LOSE }

signal game_state_changed(state)
signal treasure_collected
signal player_died

# ----- EVENTS -----
func emit_treasure_collected():
	emit_signal("treasure_collected")

func emit_player_died():
	set_game_state(GameState.LOSE)
	emit_signal("player_died")

# ----- LEVEL FLOW -----
var levels := [
	"res://scenes/level/level_1.tscn",
	"res://scenes/level/level_2.tscn",
	"res://scenes/level/level_3.tscn",
	"res://scenes/level/level_4.tscn",
]

var current_level_index := 0
var is_changing_level := false
var game_state := GameState.PLAYING

func set_game_state(state: GameState):
	if game_state == state:
		return

	game_state = state
	print("🎮 GameState →", GameState.keys()[state])
	emit_signal("game_state_changed", state)



func beat_the_game() -> bool:
	return current_level_index + 1 >= levels.size()


func go_to_next_level():
	if is_changing_level:
		return # chống double click / double emit

	is_changing_level = true
	game_state = GameState.PLAYING

	await get_tree().process_frame

	var next_index := current_level_index + 1
	if next_index >= levels.size():
		print("🎉 All levels completed!")
		current_level_index = 0
		await _change_scene_async("res://scenes/main_game.tscn")
	else:
		current_level_index = next_index
		await _change_scene_async(levels[current_level_index])

	is_changing_level = false


# ----- WEB SAFE SCENE CHANGE -----
func _change_scene_async(path: String) -> void:
	ResourceLoader.load_threaded_request(path)

	while true:
		var status = ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			break
		await get_tree().process_frame

	var packed_scene: PackedScene = ResourceLoader.load_threaded_get(path)
	get_tree().change_scene_to_packed(packed_scene)
