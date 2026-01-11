extends CanvasLayer

@onready var label = $Panel/MessageLabel
@onready var restart_btn = $Panel/RestartButton
@onready var game_over_btn : Button = $Panel/GameOverButton
@onready var next_btn : Button = $Panel/NextButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Panel_hide()
	
	restart_btn.pressed.connect(_on_restart_pressed)
	next_btn.pressed.connect(_on_next_pressed)
	game_over_btn.pressed.connect(_on_game_over_button_pressed)
	
	Globals.game_state_changed.connect(_on_game_state_changed)
	Globals.player_died.connect(_on_player_die)
	Globals.treasure_collected.connect(_on_treasure_collected)
	

func _on_treasure_collected():
	$Panel.visible = true

func _on_player_die():
	$Panel.visible = true

func _on_game_state_changed(state):	
	match state:
		Globals.GameState.WIN:
			show_message("🎉 YOU WIN!")
			print("Globals.beat_the_game()" + str(Globals.beat_the_game()))
			if Globals.beat_the_game():
				next_btn.text = "You beat the game!!!"
				next_btn.add_theme_font_size_override("font_size", 80)
			next_btn.show()
			get_tree().paused = true

		Globals.GameState.LOSE:
			show_message("💀 PLAYER DIE")
			restart_btn.show()
			get_tree().paused = true
		
		Globals.GameState.GAME_OVER:
			show_message("💀 GAME OVER")
			game_over_btn.show()
			get_tree().paused = true

func show_message(text):
	label.text = text
	$Panel.visible = true
	game_over_btn.hide()
	next_btn.hide()
	restart_btn.hide()

func Panel_hide():
	$Panel.visible = false

func _on_next_pressed():
	MusicManager.unlock_audio() # 👈 web unlock
	get_tree().paused = false
	Globals.set_game_state(Globals.GameState.PLAYING)
	Globals.go_to_next_level()
	
func _on_restart_pressed():
	MusicManager.unlock_audio() # 👈 web unlock
	get_tree().paused = false
	Globals.set_game_state(Globals.GameState.PLAYING)
	get_tree().reload_current_scene()
		
	
func _on_game_over_button_pressed():
	MusicManager.unlock_audio()
	get_tree().paused = false
	Globals.set_game_state(Globals.GameState.PLAYING)
	Globals.change_scene_async("res://scenes/main_game.tscn")
