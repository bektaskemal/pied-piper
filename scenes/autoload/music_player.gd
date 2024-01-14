extends AudioStreamPlayer

const SPEED_UP_FACTOR = 0.04

func _ready():
	GameEvents.difficulty_changed.connect(on_new_difficulty)
	

func on_new_difficulty(difficulty: float):
	pitch_scale = min(1.0 + (difficulty * SPEED_UP_FACTOR), 3.0)
	var bus_pitch_effect = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
	bus_pitch_effect.pitch_scale = 1.0 / pitch_scale
	
