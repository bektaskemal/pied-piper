extends CanvasLayer

@onready var panel_container = %PanelContainer

var options_scene = preload("res://scenes/UI/options_menu.tscn")

var is_closing = false
var options_instance: Node

func _ready():
	get_tree().paused = true
	%ResumeButton.grab_focus()
	%ResumeButton.pressed.connect(on_resume_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if options_instance == null:
			close()
		else:
			options_instance.queue_free()
		get_tree().root.set_input_as_handled()
	elif event.is_action_pressed("ui_back") and options_instance != null:
		close_options()
		get_tree().root.set_input_as_handled()

func close():
	if is_closing:
		return
	is_closing = true
	$AnimationPlayer.play("out")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	get_tree().paused = false
	queue_free()
	
func on_resume_pressed():
	close()

func on_options_pressed():
	options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(close_options)
	
func close_options():
	options_instance.queue_free()
	%OptionsButton.grab_focus()
		
func on_quit_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
	
