extends Node
class_name GameFlowManager

var gameplay_bgm: AudioStream = preload("res://assets/audio/scary.mp3")
var win_bgm: AudioStream = preload("res://assets/audio/won.wav")
var lose_bgm: AudioStream = preload("res://assets/audio/enemy-hit.wav")

var _pending_state := Globals.game_state

func _ready():
	# Lắng nghe audio ready
	if not MusicManager.audio_ready.is_connected(_on_audio_ready):
		MusicManager.audio_ready.connect(_on_audio_ready)

func _enter_tree():
	if not Globals.game_state_changed.is_connected(_on_game_state_changed):
		Globals.game_state_changed.connect(_on_game_state_changed)

	if not Globals.treasure_collected.is_connected(_on_win):
		Globals.treasure_collected.connect(_on_win)

	if not Globals.player_died.is_connected(_on_lose):
		Globals.player_died.connect(_on_lose)

func _on_game_state_changed(state):
	_pending_state = state
	_try_play_music()

func _on_audio_ready():
	_try_play_music()

func _try_play_music():
	if not MusicManager.audio_unlocked:
		return

	match _pending_state:
		Globals.GameState.PLAYING:
			MusicManager.play(gameplay_bgm)
		Globals.GameState.WIN:
			MusicManager.play(win_bgm, false)
		Globals.GameState.LOSE:
			MusicManager.play(lose_bgm, false)

func _on_win():
	if Globals.game_state == Globals.GameState.PLAYING:
		Globals.set_game_state(Globals.GameState.WIN)

func _on_lose():
	if Globals.game_state == Globals.GameState.PLAYING:
		Globals.set_game_state(Globals.GameState.LOSE)
