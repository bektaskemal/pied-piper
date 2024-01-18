extends CanvasLayer

var options_scene = preload("res://scenes/UI/options_menu.tscn")
var pressed = false
var options_instance: Node

func _ready():
	%PlayButton.grab_focus()
	%PlayButton.pressed.connect(on_play_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	if OS.has_feature("web"):
		%QuitButton.visible = false
	
func _process(delta):
	if pressed and not $AnimationPlayer.is_playing():
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")	

func _unhandled_input(event):
	if  options_instance != null and\
	 (event.is_action_pressed("pause") or event.is_action_pressed("ui_back")) :
		options_instance.queue_free()
		get_tree().root.set_input_as_handled()

func on_play_pressed():
	$AnimationPlayer.play("out")
	pressed = true
	
func on_options_pressed():
	options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))
	
func on_options_closed(instance: Node):
	instance.queue_free()	
		
func on_quit_pressed():
	get_tree().quit()
	
