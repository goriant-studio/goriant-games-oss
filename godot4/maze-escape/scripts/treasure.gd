extends Area2D
signal collected

@onready var sfx: AudioStreamPlayer2D = $SFX
@export var gold_amount: int = 1

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		sfx.play()
		collected.emit()
		queue_free()
