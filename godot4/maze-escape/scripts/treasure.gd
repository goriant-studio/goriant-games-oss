extends Area2D

@onready var sfx: AudioStreamPlayer2D = $SFX
@export var gold_amount: int = 1

func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Hit player - emit global treasure collected")
		sfx.play()
		Globals.emit_treasure_collected()
		queue_free()
