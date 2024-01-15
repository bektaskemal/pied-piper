extends CanvasLayer

var pressed = false

func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	if OS.has_feature("web"):
		%QuitButton.visible = false
	
func on_play_pressed():
	$AnimationPlayer.play("out")
	pressed = true
	

func _process(delta):
	if pressed and not $AnimationPlayer.is_playing():
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
		
func on_quit_pressed():
	get_tree().quit()
	
