extends Node

signal audio_ready

const MUSIC_BUS_NAME := "Master"
const DEFAULT_VOLUME_DB := -12

var bgm: AudioStreamPlayer
var audio_unlocked := false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	bgm = AudioStreamPlayer.new()
	bgm.bus = MUSIC_BUS_NAME
	bgm.volume_db = DEFAULT_VOLUME_DB
	bgm.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(bgm)

	print("✅ MusicManager ready (Godot 4.5 Web-safe)")

func unlock_audio():
	if audio_unlocked:
		return

	audio_unlocked = true
	print("🔓 Audio unlocked by user interaction")

	# 🚨 KHÔNG gọi AudioServer.resume() trong Godot 4
	audio_ready.emit()

func play(stream: AudioStream, loop := true):
	if not audio_unlocked:
		print("⛔ play() called before audio unlocked")
		return

	if stream == null:
		return

	if bgm.stream == stream and bgm.playing:
		return

	# Loop config (Godot 4 compatible)
	if stream is AudioStreamMP3:
		stream.loop = loop
	elif stream is AudioStreamOggVorbis:
		stream.loop = loop
	elif stream is AudioStreamWAV:
		stream.loop_mode = (
			AudioStreamWAV.LOOP_FORWARD
			if loop
			else AudioStreamWAV.LOOP_DISABLED
		)

	bgm.stop()
	bgm.stream = stream
	bgm.play()

	print("🎵 Playing:", stream.resource_path)
