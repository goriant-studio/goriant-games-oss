extends Node

const MUSIC_BUS_NAME := "Music"
const DEFAULT_VOLUME_DB := 0.0

var bgm: AudioStreamPlayer
var audio_unlocked := false

func _ready():
	bgm = AudioStreamPlayer.new()
	bgm.bus = MUSIC_BUS_NAME
	bgm.volume_db = DEFAULT_VOLUME_DB
	add_child(bgm)

	print("✅ MusicManager ready (Godot 4.5)")

# ⭐️ Chỉ là FLAG logic – không gọi AudioServer.resume()
func unlock_audio():
	if audio_unlocked:
		return

	audio_unlocked = true
	print("🔓 Audio unlocked by user interaction")

func play(stream: AudioStream, loop := true):
	if stream == null:
		return

	if not audio_unlocked:
		print("⛔ Audio locked (waiting for user interaction)")
		return

	# Loop config (Godot 4.5)
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

	bgm.stream = stream
	bgm.play()
	print("🎵 Playing:", stream.resource_path)

func stop():
	if bgm.playing:
		bgm.stop()

func set_volume(db: float):
	bgm.volume_db = db
