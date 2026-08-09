extends Node

## Procedural Sound Manager for Lumina Echoes

var sfx_player: AudioStreamPlayer
var music_player: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = &"SFX"
	add_child(sfx_player)
	
	music_player = AudioStreamPlayer.new()
	music_player.bus = &"Music"
	add_child(music_player)

func play_sfx_type(sfx_name: String) -> void:
	match sfx_name:
		"lantern_shift":
			_play_procedural_chime(660.0, 0.25)
		"ui_click":
			_play_procedural_click(880.0, 0.05)
		"ui_hover":
			_play_procedural_click(440.0, 0.03)
		"puzzle_solved":
			_play_procedural_chord()
		"interact":
			_play_procedural_chime(523.25, 0.15)

func _play_procedural_chime(freq: float, duration: float) -> void:
	var sample_rate = 22050
	var num_samples = int(sample_rate * duration)
	var buffer = PackedByteArray()
	
	for i in range(num_samples):
		var t = float(i) / float(sample_rate)
		var envelope = exp(-t * 8.0)
		var sample_val = sin(TAU * freq * t) * envelope * 0.4
		var byte_val = int(clamp((sample_val + 1.0) * 127.5, 0, 255))
		buffer.append(byte_val)
		
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_8_BITS
	stream.mix_rate = sample_rate
	stream.data = buffer
	
	var player = AudioStreamPlayer.new()
	player.bus = &"SFX"
	player.stream = stream
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func _play_procedural_click(freq: float, duration: float) -> void:
	var sample_rate = 22050
	var num_samples = int(sample_rate * duration)
	var buffer = PackedByteArray()
	
	for i in range(num_samples):
		var t = float(i) / float(sample_rate)
		var envelope = exp(-t * 30.0)
		var sample_val = (1.0 if sin(TAU * freq * t) > 0 else -1.0) * envelope * 0.25
		var byte_val = int(clamp((sample_val + 1.0) * 127.5, 0, 255))
		buffer.append(byte_val)
		
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_8_BITS
	stream.mix_rate = sample_rate
	stream.data = buffer
	
	var player = AudioStreamPlayer.new()
	player.bus = &"SFX"
	player.stream = stream
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func _play_procedural_chord() -> void:
	var freqs = [523.25, 659.25, 783.99, 1046.50] # C Major Chord
	for f in freqs:
		_play_procedural_chime(f, 1.2)
