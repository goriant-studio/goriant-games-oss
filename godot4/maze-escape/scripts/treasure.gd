extends Area2D

@onready var sfx: AudioStreamPlayer2D = $SFX
@export var gold_amount: int = 1


func _on_treasure_body_entered(body: Node2D) -> void:
	print("Hit player - emit global treasure collected")
	sfx.play()
	Globals.emit_treasure_collected()
	queue_free()

func _physics_process(_delta: float) -> void:
	if Input.is_key_pressed(Key.KEY_P):
		if not monitoring:
			monitoring = true
		if not monitorable:
			monitorable = true
		if not visible:
			visible = true
