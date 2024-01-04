extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = %Label as Label # works because we set it to unique name, otherwise $MarginContainer/Label

func _process(delta):
	if arena_time_manager == null:
		return
	var time_left = arena_time_manager.get_time_left()
	label.text = format_seconds_to_str(time_left)
	

func format_seconds_to_str(time_in_secs: float):
	var mins = floor(time_in_secs/60)
	var secs = floor(time_in_secs - (mins * 60))
	return str(mins) + ":" + ("%02d" % secs)
	