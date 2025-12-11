extends CanvasLayer

@export var start_btn : Button
@export var quit_btn : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if start_btn:
		start_btn.pressed.connect(_on_start_pressed)
	else:
		push_error("Start button is not assigned")
	
	if quit_btn:
		quit_btn.pressed.connect(_on_quit_pressed)
	else:
		push_error("Quit button is not assigned")
		
func _on_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_quit_pressed():
	get_tree().quit()
