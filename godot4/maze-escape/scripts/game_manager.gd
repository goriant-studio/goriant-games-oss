extends Node
class_name GameFlowManager

@export var gameplay_bgm: AudioStream
@export var win_bgm: AudioStream
@export var lose_bgm: AudioStream

func _enter_tree():
	if not Globals.treasure_collected.is_connected(_on_win):
		Globals.treasure_collected.connect(_on_win)

	if not Globals.player_died.is_connected(_on_lose):
		Globals.player_died.connect(_on_lose)

	if not Globals.game_state_changed.is_connected(_on_game_state_changed):
		Globals.game_state_changed.connect(_on_game_state_changed)

func _on_game_state_changed(state):
	match state:
		Globals.GameState.PLAYING:
			MusicManager.unlock_audio()
			MusicManager.play(gameplay_bgm)

		Globals.GameState.WIN:
			MusicManager.play(win_bgm, false)

		Globals.GameState.LOSE:
			MusicManager.play(lose_bgm, false)

func _on_win():
	if Globals.game_state != Globals.GameState.PLAYING:
		return
	Globals.game_state = Globals.GameState.WIN

func _on_lose():
	if Globals.game_state != Globals.GameState.PLAYING:
		return
	Globals.game_state = Globals.GameState.LOSE
