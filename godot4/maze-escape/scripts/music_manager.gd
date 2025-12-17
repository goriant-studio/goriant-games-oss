extends Node

var bgm: AudioStreamPlayer

func _ready():
	bgm = AudioStreamPlayer.new()
	bgm.bus = "Music"
	add_child(bgm)

func play(stream: AudioStream, loop := true):
	bgm.volume_db = -12
	bgm.stream = stream
	bgm.stream.loop = loop
	bgm.play()

func stop():
	if bgm.playing:
		bgm.stop()
