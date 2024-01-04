extends Node

@export var end_screen_scene: PackedScene

@onready var player = %Player as Player

var focus_out = false

func _ready():
	randomize()
	player.health_component.died.connect(on_died)
	
func on_died():
	var defeat_screen = end_screen_scene.instantiate()
	add_child(defeat_screen)
	defeat_screen.set_defeat()
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN || what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		if focus_out:
			focus_out = false
			get_tree().paused = false
	elif what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT || what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		if not get_tree().paused:
			focus_out = true
			get_tree().paused = true
		
