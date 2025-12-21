extends Node
class_name GameFlowManager

func _enter_tree():
	if not Globals.treasure_collected.is_connected(_on_win):
		Globals.treasure_collected.connect(_on_win)

	if not Globals.player_died.is_connected(_on_lose):
		Globals.player_died.connect(_on_lose)

func _on_win():
	if Globals.game_state != Globals.GameState.PLAYING:
		return
	Globals.game_state = Globals.GameState.WIN

func _on_lose():
	if Globals.game_state != Globals.GameState.PLAYING:
		return
	Globals.game_state = Globals.GameState.LOSE
