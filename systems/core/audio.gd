# Audio global script
extends Node

enum REVERB_TYPE {NONE, SMALL, MEDIUM, LARGE}

var current_track: int = 0
var music_tweens: Array[Tween]
var ui_audio_player: AudioStreamPlaybackPolyphonic
var audio_pool: Array[AudioStreamPlayer2D]
var audio_index: int = 0

@onready var music_1: AudioStreamPlayer = %Music1
@onready var music_2: AudioStreamPlayer = %Music2
@onready var ui: AudioStreamPlayer = %UI

func _ready() -> void:
	# ui.play()
	# ui_audio_player = ui.get_stream_playback()
	for i in 32:
		var audio_player := AudioStreamPlayer2D.new()
		add_child(audio_player)
		audio_player.bus = "SFX"
		audio_pool.append(audio_player)

func play_ui_audio(audio: AudioStream) -> void:
	if ui_audio_player:
		ui_audio_player.play_stream(audio)

func play_music(audio: AudioStream) -> void:
	var current_player: AudioStreamPlayer = get_music_player(current_track)
	if current_player.stream == audio:
		return
	
	var next_track: int = wrapi(current_track + 1, 0, 2)
	var next_player: AudioStreamPlayer = get_music_player(next_track)

	next_player.stream = audio
	next_player.play()

	for t in music_tweens:
		t.kill()
	music_tweens.clear()

	fade_track_out(current_player)
	fade_track_in(next_player)

	current_track = next_track

func fade_track_out(player: AudioStreamPlayer) -> void:
	var tween: Tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 0.0, 1.5)
	tween.tween_callback(player.stop)

func fade_track_in(player: AudioStreamPlayer) -> void:
	var tween: Tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 1.0, 1.0)

func get_music_player(i: int) -> AudioStreamPlayer:
	if i == 0:
		return music_1
	else:
		return music_2

func set_reverb(type: REVERB_TYPE) -> void:
	var reverb_fx: AudioEffectReverb = AudioServer.get_bus_effect(1, 0)
	if not reverb_fx:
		return
	AudioServer.set_bus_effect_enabled(1, 0, true)
	match type:
		REVERB_TYPE.NONE:
			AudioServer.set_bus_effect_enabled(1, 0, false)
		REVERB_TYPE.SMALL:
			reverb_fx.room_size = 0.2
		REVERB_TYPE.MEDIUM:
			reverb_fx.room_size = 0.5
		REVERB_TYPE.LARGE:
			reverb_fx.room_size = 0.8

func play_spatial_sound(
	audio: AudioStream,
	position: Vector2,
	ignore_pool: bool = false) -> void:
	if ignore_pool:
		var audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		add_child(audio_player)
		audio_player.bus = "SFX"
		audio_player.global_position = position
		audio_player.stream = audio
		audio_player.finished.connect(audio_player.queue_free)
		audio_player.play()
	else:
		var audio_player := audio_pool[audio_index]
		audio_player.global_position = position
		audio_player.stream = audio
		audio_player.play()
		audio_index = wrapi(audio_index + 1, 0, 32)
