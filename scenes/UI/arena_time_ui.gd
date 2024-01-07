extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = %Label as Label # works because we set it to unique name, otherwise $MarginContainer/Label

func _process(delta):
	if arena_time_manager == null:
		return
	var time_left = arena_time_manager.get_time_to_print()
	label.text = format_seconds_to_str(time_left)
	if time_left < 11:
		label.add_theme_font_size_override("font_size", 24)
	

func format_seconds_to_str(time_in_secs: float):
	var mins = floor(time_in_secs/60)
	var secs = floor(time_in_secs - (mins * 60))
	return str(mins) + ":" + ("%02d" % secs)
	
