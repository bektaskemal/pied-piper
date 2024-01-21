extends CanvasLayer

var options_scene = preload("res://scenes/UI/options_menu.tscn")
var options_instance: Node

func _ready():
	%PlayButton.grab_focus()
	%PlayButton.pressed.connect(on_play_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	if OS.has_feature("web"):
		%QuitButton.visible = false
	

func _unhandled_input(event):
	if  options_instance == null:
		return
	if	event.is_action_pressed("pause") or event.is_action_pressed("ui_back") :
		on_options_closed()
		get_tree().root.set_input_as_handled()

func on_play_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")	
	
func on_options_pressed():
	if options_instance != null:
		return
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	$MenuContainer.visible = false
	options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed)
	
func on_options_closed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	$MenuContainer.visible = true
	options_instance.queue_free()
	%OptionsButton.grab_focus()
		
func on_quit_pressed():
	get_tree().quit()
	
