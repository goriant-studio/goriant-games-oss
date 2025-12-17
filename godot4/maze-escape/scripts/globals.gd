extends Node

enum GameState { PLAYING, WIN, LOSE }

signal game_state_changed(new_state)

var game_state: GameState = GameState.PLAYING:
	set(value):
		if game_state == value:
			return
		game_state = value
		emit_signal("game_state_changed", value)
		
		
var tile_size: int = 64
var current_level = 1
