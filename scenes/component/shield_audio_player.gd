extends AudioStreamPlayer

@export var shield_up_stream: AudioStream
@export var shield_down_stream: AudioStream

func play_shield_up():
	stream = shield_up_stream
	play()
	
func play_shield_down():
	stream = shield_down_stream
	play()
