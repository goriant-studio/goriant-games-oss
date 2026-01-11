extends CenterContainer

@export var start_btn : Button
@export var difficult_opt : OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if start_btn:
		start_btn.pressed.connect(_on_start_pressed)
	else:
		push_error("Start button is not assigned")
		
		
func _on_start_pressed():
	
	if difficult_opt:
		if difficult_opt.selected == 0:
			Globals.set_game_hard(Globals.GameHard.EASY)
		elif difficult_opt.selected == 1:
			Globals.set_game_hard(Globals.GameHard.NORMAL)
		else:
			Globals.set_game_hard(Globals.GameHard.HARD)
	
	print("Globals.player_life: ", str(Globals.player_life))
	
	MusicManager.unlock_audio()
	Globals.set_game_state(Globals.GameState.PLAYING)
	get_tree().change_scene_to_file("res://scenes/level/level_1.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
