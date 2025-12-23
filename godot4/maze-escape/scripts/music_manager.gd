extends Node

const MUSIC_BUS_NAME := "Music"
const DEFAULT_VOLUME_DB := 0.0

var bgm: AudioStreamPlayer
var audio_unlocked := false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	bgm = AudioStreamPlayer.new()
	bgm.bus = MUSIC_BUS_NAME
	bgm.volume_db = DEFAULT_VOLUME_DB
	bgm.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(bgm)

	print("✅ MusicManager ready (Godot 4.5 / Web safe)")

# ⭐️ Gọi từ button / click đầu tiên của user
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

	# Prevent restart same music
	if bgm.stream == stream and bgm.playing:
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

	bgm.stop()
	bgm.stream = stream
	bgm.play()

	print("🎵 Playing:", stream.resource_path)

func stop():
	if bgm.playing:
		bgm.stop()

func set_volume(db: float):
	bgm.volume_db = db
