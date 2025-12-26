extends CanvasLayer

@onready var label = $Panel/MessageLabel
@onready var restart_btn = $Panel/RestartButton
@onready var next_btn : Button = $Panel/NextButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Panel_hide()
	restart_btn.pressed.connect(_on_restart_pressed)
	next_btn.pressed.connect(_on_next_pressed)
	Globals.game_state_changed.connect(_on_game_state_changed)
	Globals.player_died.connect(_on_player_die)


func _on_player_die():
	visible = true

func _on_game_state_changed(state):	
	match state:
		Globals.GameState.WIN:
			show_message("🎉 YOU WIN!")
			print("Globals.beat_the_game()" + str(Globals.beat_the_game()))
			if Globals.beat_the_game():
				next_btn.text = "You beat the game!!!"
				next_btn.add_theme_font_size_override("font_size", 80)
			next_btn.show()
			restart_btn.hide()
			get_tree().paused = true

		Globals.GameState.LOSE:
			show_message("💀 GAME OVER")
			restart_btn.show()
			next_btn.hide()
			get_tree().paused = true

func show_message(text):
	label.text = text
	$Panel.visible = true

func Panel_hide():
	$Panel.visible = false

func _on_restart_pressed():
	MusicManager.unlock_audio() # 👈 web unlock
	get_tree().paused = false
	Globals.set_game_state(Globals.GameState.PLAYING)
	get_tree().reload_current_scene()

func _on_next_pressed():
	MusicManager.unlock_audio() # 👈 web unlock
	get_tree().paused = false
	Globals.set_game_state(Globals.GameState.PLAYING)
	Globals.go_to_next_level()
	
