extends CanvasLayer

@export var level: String
@onready var level_label: Label = $Panel2/HBoxContainer/LevelLabel
@onready var life_lable: Label = $Panel2/HBoxContainer/PlayerLifeLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if level_label:
		level_label.text = "Level " + str(Globals.current_level_index + 1) + " - "
	if life_lable:
		life_lable.text = "Life "  + str(Globals.player_life)
