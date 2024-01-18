extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/UI/pause_menu.tscn")

@onready var player = %Player as Player


func _ready():
	randomize()
	player.health_component.died.connect(on_died)

func on_died():
	var defeat_screen = end_screen_scene.instantiate()
	add_child(defeat_screen)
	defeat_screen.set_defeat()
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT || what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		if not get_tree().paused:
			add_child(pause_menu_scene.instantiate())
		
