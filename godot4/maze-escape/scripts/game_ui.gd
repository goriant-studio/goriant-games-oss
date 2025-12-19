extends CanvasLayer

@onready var label = $Panel/MessageLabel
@onready var restart_btn = $Panel/RestartButton
@onready var next_btn = $Panel/NextButton

func _ready():
	# ⭐️ QUAN TRỌNG NHẤT
	process_mode = Node.PROCESS_MODE_ALWAYS
	Panel_hide()
	restart_btn.pressed.connect(_on_restart_pressed)
	next_btn.pressed.connect(_on_next_pressed)
	Globals.game_state_changed.connect(_on_game_state_changed)

func _on_game_state_changed(state):
	match state:
		Globals.GameState.WIN:
			show_message("🎉 YOU WIN!")
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
	print("RESTART CLICKED") # 👈 debug
	get_tree().paused = false
	Globals.game_state = Globals.GameState.PLAYING
	get_tree().reload_current_scene()

func _on_next_pressed():
	print("NEXT LEVEL") # 👈 debug
	get_tree().paused = false
	Globals.game_state = Globals.GameState.PLAYING
	Globals.go_to_next_level()
